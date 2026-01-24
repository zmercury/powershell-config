Invoke-Expression (& { (zoxide init powershell | Out-String) })
oh-my-posh init pwsh --eval --config "$PSScriptRoot\mercury.omp.json" | Invoke-Expression
Clear-Host
# fzf search and open in nvim
function fzf-nvim {
    $file = rg --files |
        fzf --preview "bat --style=numbers --color=always {}" |
        Out-String

    $file = $file.Trim()

    if ($file) {
        Start-Process nvim -ArgumentList "-- `"$file`"" -NoNewWindow -Wait
    }
}

Set-PSReadLineKeyHandler -Key Ctrl+f -ScriptBlock {
    fzf-nvim
}

