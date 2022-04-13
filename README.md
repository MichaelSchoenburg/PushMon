![GitHub](https://img.shields.io/github/license/MichaelSchoenburg/PushMon?style=plastic) ![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/michaelschoenburg/pushmon?include_prereleases&style=plastic) ![GitHub last commit](https://img.shields.io/github/last-commit/michaelschoenburg/pushmon?style=plastic) [![PSScriptAnalyzer](https://github.com/MichaelSchoenburg/PushMon/actions/workflows/powershell.yml/badge.svg)](https://github.com/MichaelSchoenburg/PushMon/actions/workflows/powershell.yml)

# PushNotification
PowerShell script that sends push notifications via Pushover for predefined monitoring methods.

# Known Issues
1. Bypass Execution Policys like this: `PowerShell.exe -ExecutionPolicy Bypass -File "$($env:USERPROFILE)\Downloads\New-PushMon.ps1"`
2. The ASCII art in the code can cause an error under on computers. The error will say, there would be an unexpected "}" at line 277 position 5.

# Possible Shortcut
One could create a shortcut containing this command (if the script is placed in the current users downloads folder).

`PowerShell.exe -ExecutionPolicy Bypass -File "%userprofile%\Downloads\New-PushMon.ps1" -Method CursorAtPos -ApiToken IncertHere -UserKey IncertHere`
