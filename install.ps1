# Installs agent-kit skills, rules, and hooks into ~/.cursor
# Does not write to ~/.cursor/skills-cursor

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$CursorHome = Join-Path $HOME ".cursor"
$SkillsSrc = Join-Path $RepoRoot "skills"
$RulesSrc = Join-Path $RepoRoot "rules"
$HooksSrc = Join-Path $RepoRoot "hooks"

$SkillsDst = Join-Path $CursorHome "skills"
$RulesDst = Join-Path $CursorHome "rules"
$HooksJsonDst = Join-Path $CursorHome "hooks.json"
$HooksDirDst = Join-Path $CursorHome "hooks"

function Test-IsLink {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function New-DirLink {
    param(
        [string]$LinkPath,
        [string]$TargetPath
    )
    if (Test-Path -LiteralPath $LinkPath) {
        if (Test-IsLink $LinkPath) {
            Remove-Item -LiteralPath $LinkPath -Force
        } else {
            Write-Host "Skip (exists, not a link): $LinkPath"
            return
        }
    }
    $parent = Split-Path -Parent $LinkPath
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }
    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
    } catch {
        New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
    }
    Write-Host "Linked $LinkPath -> $TargetPath"
}

function New-FileLink {
    param(
        [string]$LinkPath,
        [string]$TargetPath
    )
    if (Test-Path -LiteralPath $LinkPath) {
        if (Test-IsLink $LinkPath) {
            Remove-Item -LiteralPath $LinkPath -Force
        } else {
            Write-Host "Skip (exists, not a link): $LinkPath"
            return
        }
    }
    $parent = Split-Path -Parent $LinkPath
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }
    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
        Write-Host "Linked $LinkPath -> $TargetPath"
    } catch {
        Copy-Item -LiteralPath $TargetPath -Destination $LinkPath -Force
        Write-Host "Copied $TargetPath -> $LinkPath (symlink unavailable)"
    }
}

if (-not (Test-Path -LiteralPath $CursorHome)) {
    New-Item -ItemType Directory -Path $CursorHome | Out-Null
}
if (-not (Test-Path -LiteralPath $SkillsDst)) {
    New-Item -ItemType Directory -Path $SkillsDst | Out-Null
}

$linked = 0
Get-ChildItem -LiteralPath $SkillsSrc -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) { return }
    New-DirLink -LinkPath (Join-Path $SkillsDst $_.Name) -TargetPath $_.FullName
    $script:linked++
}
if ($linked -eq 0) {
    Write-Host "No skills with SKILL.md found under skills/"
}

if (-not (Test-Path -LiteralPath $RulesDst)) {
    New-Item -ItemType Directory -Path $RulesDst | Out-Null
}
Get-ChildItem -LiteralPath $RulesSrc -Filter "*.mdc" -File -ErrorAction SilentlyContinue | ForEach-Object {
    New-FileLink -LinkPath (Join-Path $RulesDst $_.Name) -TargetPath $_.FullName
}

$hooksJson = Join-Path $HooksSrc "hooks.json"
if (Test-Path -LiteralPath $hooksJson) {
    $hooks = Get-Content -LiteralPath $hooksJson -Raw | ConvertFrom-Json
    $hookCount = 0
    if ($null -ne $hooks.hooks) {
        $hookCount = @($hooks.hooks.PSObject.Properties).Count
    }
    if ($hookCount -gt 0) {
        New-FileLink -LinkPath $HooksJsonDst -TargetPath $hooksJson
        if (-not (Test-Path -LiteralPath $HooksDirDst)) {
            New-Item -ItemType Directory -Path $HooksDirDst | Out-Null
        }
        Get-ChildItem -LiteralPath $HooksSrc -File | Where-Object { $_.Name -ne "hooks.json" -and $_.Name -ne "README.md" } | ForEach-Object {
            New-FileLink -LinkPath (Join-Path $HooksDirDst $_.Name) -TargetPath $_.FullName
        }
    } else {
        Write-Host "hooks/hooks.json has no events; skipping hook install"
    }
}

Write-Host "Done."
