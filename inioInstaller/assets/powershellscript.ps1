$homeurl = "https://raw.githubusercontent.com/lordnhoj1/Inio-DOS/refs/heads/main/inio%20HOME/maincli.lua"
$BVhomeurl = "https://github.com/lordnhoj1/Inio-DOS/raw/refs/heads/main/inio%20HOME/maincli%20(BV%20port).lua"
$mainserverurl = "https://github.com/lordnhoj1/Inio-DOS/raw/refs/heads/main/inio%20SERVER/maincli.lua"
$serverurl = "https://github.com/lordnhoj1/Inio-DOS/raw/refs/heads/main/inio%20SERVER/serverhandler.lua"
function Install {
Clear-Host
Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
Write-Host "Inio Installer v1"
Write-Host "This tool is designed to help you get the latest source code for Inio.`n"
Write-Host "Current available versions: Home, Server`n`nPlease note that input is case sensitive.`nEnter your needed version in ALL LOWERCASE."
Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
Write-Host ""
$selversion = Read-Host "version"
    if ($selversion -eq "home") {
        Clear-Host
        Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
        Write-Host "Current available ports: lf3x, bv`n`nPlease note that input is case sensitive.`nEnter your needed version in ALL LOWERCASE."
        Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
        Write-Host ""
        $selport = Read-Host "port"
        if ($selport -eq "lf3x") {
            Clear-Host
            Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
            Write-Host "Thank you for choosing Inio Home LF3X.`nYour files are being downloaded."
            Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
            Write-Host ""
            Invoke-WebRequest -Uri $homeurl -Outfile "LF3Xmaincli.lua"
        }
        if ($selport -eq "bv") {
            Clear-Host
            Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
            Write-Host "Thank you for choosing Inio Home BV.`nYour files are being downloaded."
            Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
            Write-Host ""
            Invoke-WebRequest -Uri $BVhomeurl -OutFile "BVmaincli.lua"
        }
        if ($selport -notin @("lf3x", "bv")) {
            Clear-Host
            Write-Host "Invalid port." -ForegroundColor Red
            Write-Host "Let's try this again." -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            Install
        }
    }
    if ($selversion -eq "server") {
        Clear-Host
        Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
        Write-Host "Thank you for choosing Inio Server.`nYour files are being downloaded."
        Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
        Write-Host ""
        Invoke-WebRequest -Uri $mainserverurl -OutFile "maincli.lua"
        Invoke-WebRequest -Uri $serverurl -Outfile "serverhandler.lua"
    }
    if ($selversion -notin @("home","server")) {
        Clear-Host
        Write-Host "Invalid version." -ForegroundColor Red
        Write-Host "Let's try this again." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        Install
    }
    Clear-Host
    Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
    Write-Host "Inio Installer v1"
    Write-Host "This tool is designed to help you get the latest source code for Inio.`n"
    Write-Host "Your file has been downloaded!`nThank you for choosing Inio."
    Write-Host "--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~" -ForegroundColor Yellow
    Write-Host ""

    Start-Sleep -Seconds 4
    Clear-Host
    exit
}

Install
