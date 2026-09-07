# Removes agent-kit links from ~/.cursor. Leaves unrelated files in place.

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$CursorHome = Join-Path $HOME ".cursor"
$SkillsSrc = Join-Path $RepoRoot "skills"
$RulesSrc = Join-Path $RepoRoot "rules"
$HooksSrc = Join-Path $RepoRoot "hooks"

$SkillsDst = Join-Path $CursorHome "skills"
$RulesDst = Join-Path $CursorHome "rules"

function Test-IsLink {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Remove-KitLink {
    param([string]$Path)
    if (Test-IsLink $Path) {
        Remove-Item -LiteralPath $Path -Force
        Write-Host "Removed $Path"
    }
}

Get-ChildItem -LiteralPath $SkillsSrc -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-KitLink (Join-Path $SkillsDst $_.Name)
}

Get-ChildItem -LiteralPath $RulesSrc -Filter "*.mdc" -File -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-KitLink (Join-Path $RulesDst $_.Name)
}

$hooksJsonSrc = Join-Path $HooksSrc "hooks.json"
$hooksJsonDst = Join-Path $CursorHome "hooks.json"
if ((Test-Path -LiteralPath $hooksJsonSrc) -and (Test-IsLink $hooksJsonDst)) {
    Remove-KitLink $hooksJsonDst
}

$hooksDirDst = Join-Path $CursorHome "hooks"
Get-ChildItem -LiteralPath $HooksSrc -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "hooks.json" -and $_.Name -ne "README.md" } | ForEach-Object {
    Remove-KitLink (Join-Path $hooksDirDst $_.Name)
}

Write-Host "Done."
