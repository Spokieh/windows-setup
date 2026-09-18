# --- PSReadLine ---

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -BellStyle None

# --- PSFzf ---

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f'

# --- Zoxide ---

Invoke-Expression (& { (zoxide init powershell | Out-String) })

# --- Oh My Posh ---

oh-my-posh init pwsh --config catppuccin_mocha | Invoke-Expression

# --- Terminal Icons ---

Import-Module Terminal-Icons

# Existing personal convenience alias.
Set-Alias vim nvim
