<#
.SYNOPSIS
    PushMon
.DESCRIPTION
    PowerShell script that sends push notifications via Pushover for predefined monitoring methods. 
.SYNTAX
.PARAMETERS
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.RELATED LINKS
    GitHub: https://github.com/MichaelSchoenburg/T22-000215
.NOTES
    Author: Michael Schönburg
    Version: v1.0
    Last Edit: 11.02.2021
    
    This projects code loosely follows the PowerShell Practice and Style guide, as well as Microsofts PowerShell scripting performance considerations.
    Style guide: https://poshcode.gitbook.io/powershell-practice-and-style/
    Performance Considerations: https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations?view=powershell-7.1
.REMARKS
    To see the examples, type: "get-help Get-HotFix -examples".
    For more information, type: "get-help Get-HotFix -detailed".
    For technical information, type: "get-help Get-HotFix -full".
    For online help, type: "get-help Get-HotFix -online"
#>

#region RULES

# Rules/Conventions:

#     # This is a comment related to the following command

#     <# 
#         This is a comment related to the next couple commands (most times a caption for a section)
#     #>

# "This is a Text containing $( $variable(s) )"

# 'This is a text without variable(s)'

# Variables available in the entire script start with a capital letter
# $ThisIsAGlobalVariable

# Variables available only locally e. g. in a function start with a lower case letter
# $thisIsALocalVariable

#endregion RULES
#region INITIALIZATION
<# 
    Libraries, Modules, ...
#>

[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true
    )]
    [ValidateSet('ColorAtPos')]
    [string]
    $Method = 'ColorAtPos',

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $ApiToken,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $UserKey
)

#endregion INITIALIZATION
#region DECLARATIONS
<#
    Declare local variables and global variables
#>

# None, yet.

#endregion DECLARATIONS
#region FUNCTIONS
<# 
    Declare Functions
#>

function Write-ConsoleLog {
    <#
    .SYNOPSIS
    Logs an event to the console.
    
    .DESCRIPTION
    Writes text to the console with the current date (US format) in front of it.
    
    .PARAMETER Text
    Event/text to be outputted to the console.
    
    .EXAMPLE
    Write-ConsoleLog -Text 'Subscript XYZ called.'
    
    Long form
    .EXAMPLE
    Log 'Subscript XYZ called.
    
    Short form
    #>
    [alias('Log')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
        Position = 0)]
        [string]
        $Text
    )

    # Save current VerbosePreference
    $VerbosePreferenceBefore = $VerbosePreference

    # Enable verbose output
    $VerbosePreference = 'Continue'

    # Write verbose output
    Write-Verbose "$( Get-Date -Format 'MM/dd/yyyy HH:mm:ss' ) - $( $Text )"

    # Restore current VerbosePreference
    $VerbosePreference = $VerbosePreferenceBefore
}

function Get-ScreenColor {
    <#
    .SYNOPSIS
    Gets the color of the pixel under the mouse, or of the specified space.
    .DESCRIPTION
    Returns the pixel color either under the mouse, or of a location onscreen using X/Y locating.  If no parameters are supplied, the mouse cursor position will be retrived and used.
 
    Current Version - 1.0
    .EXAMPLE
    Mouse-Color
    Returns the color of the pixel directly under the mouse cursor.
    .EXAMPLE
    Mouse-Color -X 300 -Y 300
    Returns the color of the pixel 300 pixels from the top of the screen and 300 pixels from the left.
    .PARAMETER X
    Distance from the top of the screen to retrieve color, in pixels.
    .PARAMETER Y
    Distance from the left of the screen to retrieve color, in pixels.
    .NOTES
    Author: Malil
    Source: https://community.spiceworks.com/scripts/show/4263-get-screencolor
 
    Revision History
    Version 1.0
        - Live release.  Contains two parameter sets - an empty default, and an X/Y set.
    #>
 
    #Requires -Version 4.0
 
    [CmdletBinding(DefaultParameterSetName='None')]
 
    param(
        [Parameter(
            Mandatory=$true,
            ParameterSetName="Pos"
        )]
        [Int]
        $X,
        [Parameter(
            Mandatory=$true,
            ParameterSetName="Pos"
        )]
        [Int]
        $Y
    )
     
    if ($PSCmdlet.ParameterSetName -eq 'None') {
        $pos = [System.Windows.Forms.Cursor]::Position
    } else {
        $pos = New-Object psobject
        $pos | Add-Member -MemberType NoteProperty -Name "X" -Value $X
        $pos | Add-Member -MemberType NoteProperty -Name "Y" -Value $Y
    }
    $map = [System.Drawing.Rectangle]::FromLTRB($pos.X, $pos.Y, $pos.X + 1, $pos.Y + 1)
    $bmp = New-Object System.Drawing.Bitmap(1,1)
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($map.Location, [System.Drawing.Point]::Empty, $map.Size)
    $pixel = $bmp.GetPixel(0,0)
    $red = $pixel.R
    $green = $pixel.G
    $blue = $pixel.B
    $result = New-Object psobject
    if ($PSCmdlet.ParameterSetName -eq 'None') {
        $result | Add-Member -MemberType NoteProperty -Name "X" -Value $([System.Windows.Forms.Cursor]::Position).X
        $result | Add-Member -MemberType NoteProperty -Name "Y" -Value $([System.Windows.Forms.Cursor]::Position).Y
    }
    $result | Add-Member -MemberType NoteProperty -Name "Red" -Value $red
    $result | Add-Member -MemberType NoteProperty -Name "Green" -Value $green
    $result | Add-Member -MemberType NoteProperty -Name "Blue" -Value $blue
    return $result
}
 
function Get-MousePosition {
    Add-Type -AssemblyName System.Windows.Forms
 
    $x = [System.Windows.Forms.Cursor]::Position.X
    $y = [System.Windows.Forms.Cursor]::Position.Y
 
    return $x, $y
}

#endregion FUNCTIONS
#region EXECUTION
<# 
    Script entry point
#>

Write-Host "
██████  ██    ██ ███████ ██   ██ ███    ███  ██████  ███    ██   ▄▀ ▄▀    
██   ██ ██    ██ ██      ██   ██ ████  ████ ██    ██ ████   ██    ▀  ▀    
██████  ██    ██ ███████ ███████ ██ ████ ██ ██    ██ ██ ██  ██  █▀▀▀▀▀█▄  
██      ██    ██      ██ ██   ██ ██  ██  ██ ██    ██ ██  ██ ██  █░░░░░█─█ 
██       ██████  ███████ ██   ██ ██      ██  ██████  ██   ████  ▀▄▄▄▄▄▀▀  
                           by Michael Schönburg                                                                               
     __                                                             
    |__  _  | _    _ _||_  _  _|    _  _| _ . _ . _|_ _ _ |_. _  _  
    |(_)|   |(_|\/(-(_||_)(_|(_|(  (_|(_|||||| )|_)|_| (_||_|(_)| ) 
                /                                                   
" -ForegroundColor Yellow
# Font from https://patorjk.com/software/taag
# Coffee from https://fsymbols.com/text-art/twitter/#all_cats
"-------------------------------------------------------------------------
Your specified monitoring method     = $( $Method )
Your specified API token             = $( $ApiToken )
Your specified user key              = $( $UserKey )
"

switch ($Method) {
    'ColorAtPos' {
        Write-Host "Hover over the position with your mouse and press any key to monitor it..."
        $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        $x, $y = Get-MousePosition
        $InitialColor = Get-ScreenColor -X $x -Y $y
         
        # Monitoring
        do {
            Clear-Host
            Write-Host "Mouse position = x: $( $x ) y: $( $y )"
            Write-Host "Initial color = $( $InitialColor )"
            Write-Host 'Monitoring Color...'
            Start-Sleep -Seconds 1
            $CurrentColor = Get-ScreenColor -X $X -Y $Y
        } until ($CurrentColor.PSObject.ToString() -ne $InitialColor.PSObject.ToString())
         
        Write-Host 'Color at given screen position has changed. Sending notification...' -ForegroundColor Yellow
         
        $apiKeyUrl = "https://api.pushover.net/1/messages.json"
         
        # This is the notification data, which gets converted to JSON
        $body = @{
            "token"=$ApiToken
            "user"=$UserKey
            "message"="The color at the given screen position has changed."
        } | ConvertTo-Json
        
        # This header tells we're passing a JSON payload
        $header = @{
            "Content-Type"="application/json"
        }
         
        # Notify17 invocation
        Invoke-RestMethod -Uri $apiKeyUrl -Method 'Post' -Body $body -Headers $header
    }
}

#endregion EXECUTION
