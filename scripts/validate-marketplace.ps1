param(
    [string]$MarketplacePath = ".agents/plugins/marketplace.json"
)

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

function Require-Property($Object, [string]$Property, [string]$Context) {
    if ($null -eq $Object -or -not $Object.PSObject.Properties.Name.Contains($Property)) {
        Fail "$Context is missing required field '$Property'."
    }
}

function Resolve-RepoPath([string]$BasePath, [string]$RelativePath) {
    $cleanPath = $RelativePath
    if ($cleanPath.StartsWith("./")) {
        $cleanPath = $cleanPath.Substring(2)
    }
    return Join-Path $BasePath $cleanPath
}

if (-not (Test-Path -LiteralPath $MarketplacePath)) {
    Fail "Marketplace file not found: $MarketplacePath"
}

try {
    $marketplace = Get-Content -Raw -LiteralPath $MarketplacePath | ConvertFrom-Json
}
catch {
    Fail "Marketplace JSON is invalid: $($_.Exception.Message)"
}

Require-Property $marketplace "name" "Marketplace"
Require-Property $marketplace "plugins" "Marketplace"

$plugins = @($marketplace.plugins)
if ($plugins.Count -lt 1) {
    Fail "Expected at least one plugin entry."
}

$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Resolve-Path -LiteralPath $MarketplacePath)))
$pluginNames = @{}
$skillCount = 0

foreach ($plugin in $plugins) {
    foreach ($field in @("name", "source", "policy", "category")) {
        Require-Property $plugin $field "Plugin entry"
    }

    if ([string]::IsNullOrWhiteSpace($plugin.name)) {
        Fail "Plugin name must not be empty."
    }

    if ($pluginNames.ContainsKey($plugin.name)) {
        Fail "Duplicate plugin name: $($plugin.name)"
    }
    $pluginNames[$plugin.name] = $true

    Require-Property $plugin.source "source" "Plugin '$($plugin.name)' source"
    Require-Property $plugin.source "path" "Plugin '$($plugin.name)' source"
    if ($plugin.source.source -ne "local") {
        Fail "Plugin '$($plugin.name)' must use source.source = local."
    }

    Require-Property $plugin.policy "installation" "Plugin '$($plugin.name)' policy"
    Require-Property $plugin.policy "authentication" "Plugin '$($plugin.name)' policy"

    $allowedInstallation = @("NOT_AVAILABLE", "AVAILABLE", "INSTALLED_BY_DEFAULT")
    $allowedAuthentication = @("ON_INSTALL", "ON_USE")
    if ($plugin.policy.installation -notin $allowedInstallation) {
        Fail "Plugin '$($plugin.name)' has invalid policy.installation: $($plugin.policy.installation)"
    }
    if ($plugin.policy.authentication -notin $allowedAuthentication) {
        Fail "Plugin '$($plugin.name)' has invalid policy.authentication: $($plugin.policy.authentication)"
    }

    $pluginPath = Resolve-RepoPath $repoRoot $plugin.source.path
    $pluginManifestPath = Join-Path $pluginPath ".codex-plugin/plugin.json"
    if (-not (Test-Path -LiteralPath $pluginManifestPath)) {
        Fail "Plugin '$($plugin.name)' manifest not found: $pluginManifestPath"
    }

    try {
        $pluginManifest = Get-Content -Raw -LiteralPath $pluginManifestPath | ConvertFrom-Json
    }
    catch {
        Fail "Plugin '$($plugin.name)' manifest JSON is invalid: $($_.Exception.Message)"
    }

    foreach ($field in @("name", "version", "description", "skills", "interface")) {
        Require-Property $pluginManifest $field "Plugin '$($plugin.name)' manifest"
    }

    if ($pluginManifest.name -ne $plugin.name) {
        Fail "Plugin manifest name '$($pluginManifest.name)' does not match marketplace entry '$($plugin.name)'."
    }

    $expectedFolderName = Split-Path -Leaf $pluginPath
    if ($pluginManifest.name -ne $expectedFolderName) {
        Fail "Plugin manifest name '$($pluginManifest.name)' does not match folder '$expectedFolderName'."
    }

    $skillsPath = Resolve-RepoPath $pluginPath $pluginManifest.skills
    if (-not (Test-Path -LiteralPath $skillsPath)) {
        Fail "Plugin '$($plugin.name)' skills directory not found: $skillsPath"
    }

    $skillDirectories = @(Get-ChildItem -LiteralPath $skillsPath -Directory)
    if ($skillDirectories.Count -lt 1) {
        Fail "Plugin '$($plugin.name)' must include at least one skill directory."
    }

    foreach ($skillDirectory in $skillDirectories) {
        $skillEntrypoint = Join-Path $skillDirectory.FullName "SKILL.md"
        if (-not (Test-Path -LiteralPath $skillEntrypoint)) {
            Fail "Skill '$($skillDirectory.Name)' entrypoint not found: $skillEntrypoint"
        }

        $skillText = Get-Content -Raw -LiteralPath $skillEntrypoint
        if ($skillText -notmatch "(?s)^---\s*\r?\n.*?\bname:\s*$([regex]::Escape($skillDirectory.Name))\b.*?\r?\n---") {
            Fail "Skill '$($skillDirectory.Name)' frontmatter does not declare name: $($skillDirectory.Name)."
        }

        $skillCount += 1
    }
}

Write-Host "Plugin marketplace validation passed ($($plugins.Count) plugins, $skillCount skills)."
