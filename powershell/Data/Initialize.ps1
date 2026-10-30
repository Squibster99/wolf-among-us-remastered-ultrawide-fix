# Loads the included readable C# helpers using Windows PowerShell's Add-Type.
# No downloaded tools, registry edits or execution-policy changes are performed.
$ErrorActionPreference='Stop'
if($PSVersionTable.PSEdition -eq 'Core'){
    throw 'Please run this edition with Windows PowerShell 5.1 (powershell.exe), rather than PowerShell 7 (pwsh.exe).'
}
if(-not ('UltrawidePowerShell' -as [type])){
    Add-Type -Path @((Join-Path $PSScriptRoot 'Core.cs'),(Join-Path $PSScriptRoot 'Blowfish.cs'),(Join-Path $PSScriptRoot 'PowerShellBridge.cs')) -ReferencedAssemblies @('System.dll','System.Core.dll','System.Xml.dll','System.Xml.Linq.dll')
}
[UltrawidePowerShell]::Initialize($PSScriptRoot)
