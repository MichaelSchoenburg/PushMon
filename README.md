# PushNotification
PowerShell script that sends push notifications via Pushover for predefined monitoring methods.

# Known Issues
1. Bypass Execution Policys like this: `PowerShell.exe -ExecutionPolicy Bypass -File "$($env:USERPROFILE)\Downloads\New-PushMon.ps1"`
2. The ASCII art in the code can cause an error under on computers. The error will say, there would be an unexpected "}" at line 277 position 5.

# Possible Shortcut
One could create a shortcut containing this command (if the script is placed in the current users downloads folder).

`PowerShell.exe -ExecutionPolicy Bypass -File "%userprofile%\Downloads\New-PushMon.ps1" -Method CursorAtPos -ApiToken IncertHere -UserKey IncertHere`
