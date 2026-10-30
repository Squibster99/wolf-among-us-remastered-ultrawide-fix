# The Wolf Among Us Remastered - Ultrawide Fix, PowerShell edition 0.1.2
[CmdletBinding()]
param(
    [ValidateSet('Menu','Install','Undo','Check')][string]$Action='Menu',
    [string]$GameFolder='',
    [ValidateRange(800,16384)][int]$Width=3440,
    [ValidateRange(600,8640)][int]$Height=1440,
    [switch]$NonInteractive
)
$ErrorActionPreference='Stop'
$exitCode=0
try {
    . (Join-Path $PSScriptRoot 'Data\Initialize.ps1')
    if([string]::IsNullOrWhiteSpace($GameFolder)){
        $default=Join-Path ${env:ProgramFiles(x86)} 'Steam\steamapps\common\The Wolf Among Us Remastered'
        if($NonInteractive){throw 'Supply -GameFolder when using -NonInteractive.'}
        Write-Host 'The Wolf Among Us Remastered - Ultrawide Fix (PowerShell)' -ForegroundColor Cyan
        Write-Host "Game folder [press Enter for $default]"
        $GameFolder=Read-Host
        if([string]::IsNullOrWhiteSpace($GameFolder)){$GameFolder=$default}
        $GameFolder=$GameFolder.Trim().Trim('"')
    }
    if($Action -eq 'Menu'){
        if($NonInteractive){throw 'Choose -Action Install, Undo or Check with -NonInteractive.'}
        Write-Host ''
        Write-Host '1. Install or update'
        Write-Host '2. Undo setup changes'
        Write-Host '3. Check game compatibility (no changes)'
        Write-Host '4. Exit'
        switch((Read-Host 'Choose 1-4').Trim()){
            '1' {$Action='Install'}
            '2' {$Action='Undo'}
            '3' {$Action='Check'}
            '4' {return}
            default {throw 'Invalid menu choice.'}
        }
        if($Action -eq 'Install'){
            $display=[UltrawidePowerShell]::Display()
            Write-Host ''
            Write-Host '1. 2560 x 1080 - available for testing'
            Write-Host '2. 3440 x 1440 - underlying fix player-tested'
            Write-Host '3. 3840 x 1600 - available for testing'
            Write-Host '4. 5120 x 1440 - experimental 32:9'
            Write-Host ("5. Custom / detected primary display ({0} x {1})" -f $display[0],$display[1])
            switch((Read-Host 'Choose 1-5').Trim()){
                '1' {$Width=2560;$Height=1080}
                '2' {$Width=3440;$Height=1440}
                '3' {$Width=3840;$Height=1600}
                '4' {$Width=5120;$Height=1440}
                '5' {
                    if($display[0] -gt 0){$Width=$display[0];$Height=$display[1]}
                    $v=Read-Host "Width [Enter for $Width]";if(-not [string]::IsNullOrWhiteSpace($v)){$Width=[int]$v}
                    $v=Read-Host "Height [Enter for $Height]";if(-not [string]::IsNullOrWhiteSpace($v)){$Height=[int]$v}
                }
                default {throw 'Invalid resolution choice.'}
            }
        }
    }
    switch($Action){
        'Check' {Write-Host ([UltrawidePowerShell]::Check($GameFolder)) -ForegroundColor Green}
        'Install' {Write-Host ([UltrawidePowerShell]::Install($GameFolder,$Width,$Height)) -ForegroundColor Green}
        'Undo' {Write-Host ([UltrawidePowerShell]::Undo($GameFolder)) -ForegroundColor Green}
    }
}catch{
    $message=$_.Exception.Message
    if($_.Exception.InnerException){$message=$_.Exception.InnerException.Message}
    Write-Host ("Setup could not complete: "+$message) -ForegroundColor Red
    if($_.Exception -is [UnauthorizedAccessException] -or $message -match 'access.*denied|Access to the path'){
        Write-Host 'Open Windows PowerShell as administrator and run this script again for a protected game folder.'
    }
    $exitCode=1
}finally{
    if(-not $NonInteractive){Write-Host '';[void](Read-Host 'Press Enter to close')}
}
exit $exitCode
