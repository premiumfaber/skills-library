param(
    [string]$MarketplacePath = "marketplace.json"
)

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
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

if ($marketplace.schemaVersion -ne 1) {
    Fail "Expected schemaVersion 1."
}

$skills = @($marketplace.skills)
if ($skills.Count -lt 1) {
    Fail "Expected at least one skill entry."
}

$root = Split-Path -Parent (Resolve-Path -LiteralPath $MarketplacePath)
$ids = @{}
$requiredFields = @("id", "name", "version", "description", "path", "entrypoint", "targets", "tags")

foreach ($skill in $skills) {
    foreach ($field in $requiredFields) {
        if (-not $skill.PSObject.Properties.Name.Contains($field)) {
            Fail "Skill entry is missing required field '$field'."
        }
    }

    if ([string]::IsNullOrWhiteSpace($skill.id)) {
        Fail "Skill id must not be empty."
    }

    if ($ids.ContainsKey($skill.id)) {
        Fail "Duplicate skill id: $($skill.id)"
    }
    $ids[$skill.id] = $true

    if (-not $skill.targets.PSObject.Properties.Name.Contains("codex")) {
        Fail "Skill '$($skill.id)' is missing targets.codex."
    }
    if (-not $skill.targets.PSObject.Properties.Name.Contains("claudeCode")) {
        Fail "Skill '$($skill.id)' is missing targets.claudeCode."
    }
    if ($skill.targets.codex.compatible -isnot [bool]) {
        Fail "Skill '$($skill.id)' must set targets.codex.compatible to a boolean."
    }
    if ($skill.targets.claudeCode.compatible -isnot [bool]) {
        Fail "Skill '$($skill.id)' must set targets.claudeCode.compatible to a boolean."
    }

    $skillPath = Join-Path $root $skill.path
    $entrypointPath = Join-Path $skillPath $skill.entrypoint
    if (-not (Test-Path -LiteralPath $entrypointPath)) {
        Fail "Skill '$($skill.id)' entrypoint not found: $entrypointPath"
    }

    $skillText = Get-Content -Raw -LiteralPath $entrypointPath
    if ($skillText -notmatch "(?s)^---\s*\r?\n.*?\bname:\s*$([regex]::Escape($skill.id))\b.*?\r?\n---") {
        Fail "Skill '$($skill.id)' entrypoint frontmatter does not declare name: $($skill.id)."
    }
}

Write-Host "Marketplace validation passed ($($skills.Count) skills)."
