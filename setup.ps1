[CmdletBinding(SupportsShouldProcess)]
param([switch]$Force)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Warning "$Name was not found."
        return $false
    }
    return $true
}

function Copy-SetupFile([string]$Source, [string]$Target) {
    if ((Test-Path $Target -PathType Leaf) -and -not $Force) {
        Write-Warning "Skipping existing file: $Target (use -Force to replace it)."
        return
    }
    if ((Test-Path $Target -PathType Leaf) -and $Force) {
        $backup = "$Target.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -LiteralPath $Target -Destination $backup
        Write-Host "Backed up $Target to $backup"
    }
    New-Item -ItemType Directory -Path (Split-Path $Target) -Force | Out-Null
    if ($PSCmdlet.ShouldProcess($Target, 'Copy setup file')) {
        Copy-Item -LiteralPath $Source -Destination $Target -Force
        Write-Host "Copied $Target"
    }
}

if (-not (Require-Command winget)) { throw 'winget is required.' }
if ($PSCmdlet.ShouldProcess('winget packages', 'Install or update')) {
    winget source update --accept-source-agreements
    foreach ($id in @('Microsoft.PowerShell','Neovim.Neovim','BurntSushi.ripgrep.MSVC','sharkdp.fd','JesseDuffield.lazygit','junegunn.fzf','JanDeDobbeleer.OhMyPosh')) {
        winget install --source winget --id $id --accept-source-agreements --accept-package-agreements
    }
}
if ((Require-Command pwsh) -and $PSCmdlet.ShouldProcess('CurrentUser PowerShell modules', 'Install')) { & pwsh -NoProfile -File (Join-Path $repo 'packages/powershell-modules.ps1') }
if ((Require-Command npm) -and $PSCmdlet.ShouldProcess('tree-sitter-cli', 'Install globally')) { npm install --global tree-sitter-cli }

if (Get-Command code -ErrorAction SilentlyContinue) {
    if ($PSCmdlet.ShouldProcess('VS Code extensions', 'Install from vscode/extensions.txt')) {
        Get-Content (Join-Path $repo 'vscode/extensions.txt') | Where-Object { $_ -and -not $_.StartsWith('#') } | ForEach-Object {
            code --install-extension $_
        }
    }
} else {
    Write-Warning 'The code command was not found; skipping VS Code extension restoration.'
}

Copy-SetupFile (Join-Path $repo 'powershell/Microsoft.PowerShell_profile.ps1') (Join-Path $HOME 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1')
Copy-SetupFile (Join-Path $repo 'vscode/settings.json') (Join-Path $env:APPDATA 'Code/User/settings.json')
Copy-SetupFile (Join-Path $repo 'vscode/keybindings.json') (Join-Path $env:APPDATA 'Code/User/keybindings.json')

$nvimTarget = Join-Path $env:LOCALAPPDATA 'nvim'
if ((Test-Path $nvimTarget -PathType Container) -and -not $Force) {
    Write-Warning "Skipping existing Neovim directory: $nvimTarget (use -Force to replace individual files)."
} else {
    if (Test-Path $nvimTarget -PathType Container) {
        $backup = "$nvimTarget.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -LiteralPath $nvimTarget -Destination $backup -Recurse
        Write-Host "Backed up $nvimTarget to $backup"
    }
    $nvimSource = Join-Path $repo 'nvim'
    Get-ChildItem $nvimSource -File -Recurse | ForEach-Object {
        $relative = $_.FullName.Substring($nvimSource.Length).TrimStart('\')
        Copy-SetupFile $_.FullName (Join-Path $nvimTarget $relative)
    }
}
Write-Host 'Setup finished. Restart PowerShell and VS Code to load the deployed configuration.'
Write-Host 'Windows Terminal settings are intentionally applied manually; see README.md.'
