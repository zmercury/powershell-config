Invoke-Expression (& { (zoxide init powershell | Out-String) })
oh-my-posh init pwsh --eval --config "$PSScriptRoot\mercury.omp.json" | Invoke-Expression
