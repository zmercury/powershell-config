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

# Live ripgrep and open in nvim
function fzf-rg-nvim {
    $result = rg --line-number --no-heading --color=never "" |
        fzf --delimiter : --preview "bat --style=numbers --color=always --highlight-line {2} {1}" |
        Out-String

    $result = $result.Trim()

    if ($result) {
        $parts = $result -split ":"
        $file = $parts[0]
        $line = $parts[1]

        Start-Process nvim -ArgumentList "+$line `"$file`"" -NoNewWindow -Wait
    }
}

Set-PSReadLineKeyHandler -Key Ctrl+x -ScriptBlock {
    fzf-rg-nvim
}

# FZF directory jump
function fzf-cd {
    $dir = fd --type d `
        --exclude node_modules `
        --exclude .git `
        --exclude dist `
        --exclude build `
        --exclude .next `
        --exclude out `
        --exclude target `
        --exclude bin `
        --exclude obj |
        fzf |
        Out-String

    $dir = $dir.Trim()

    if ($dir) {
        Set-Location $dir
    }
}

Set-PSReadLineKeyHandler -Key Ctrl+d -ScriptBlock {
    fzf-cd

    $type = [Microsoft.PowerShell.PSConsoleReadLine]

    if ($type.GetMethod("ClearLine")) {
        $type::ClearLine()
    }

    $type::InvokePrompt()
}

