param([string]$LuaCompiler = '')
$ErrorActionPreference='Stop'
$p=$PSScriptRoot
New-Item -ItemType Directory -Path (Join-Path $p 'build'),(Join-Path $p 'package') -Force|Out-Null
$compiler=Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
if(-not(Test-Path -LiteralPath $compiler)){throw 'The 64-bit .NET Framework C# compiler was not found.'}
$template=Join-Path $p 'assets\Menu_settings.template.luac'
if($LuaCompiler){
 $template=Join-Path $p 'build\Menu_settings.template.luac'
 & $LuaCompiler -s -o $template (Join-Path $p 'source\Menu_settings.lua')
 if($LASTEXITCODE -ne 0){throw 'Lua compilation failed'}
}
$header=[IO.File]::ReadAllBytes($template)
if([BitConverter]::ToString($header[0..17]) -ne '1B-4C-75-61-52-00-01-04-04-04-04-00-19-93-0D-0A-1A-0A'){throw 'Lua compiler output has the wrong ABI. Use the supplied compatible template.'}
$options=@('/nologo','/platform:x64','/optimize+','/reference:System.Core.dll','/reference:System.Xml.Linq.dll','/reference:System.Windows.Forms.dll','/reference:System.Drawing.dll',('/resource:'+$template+',template'),('/resource:'+(Join-Path $p 'source\descriptor.lua')+',descriptor'),('/win32manifest:'+(Join-Path $p 'source\setup.manifest')),('/out:'+(Join-Path $p 'package\Ultrawide Setup.exe')))
& $compiler /target:winexe @options (Join-Path $p 'source\Core.cs') (Join-Path $p 'source\Blowfish.cs') (Join-Path $p 'source\Setup.cs')
if($LASTEXITCODE -ne 0){throw 'Setup compilation failed'}
Copy-Item -LiteralPath (Join-Path $p 'docs\README.txt') -Destination (Join-Path $p 'package\README.txt')
Copy-Item -LiteralPath (Join-Path $p 'THIRD-PARTY-NOTICES.txt') -Destination (Join-Path $p 'package\THIRD-PARTY-NOTICES.txt')
Get-FileHash -LiteralPath (Join-Path $p 'package\Ultrawide Setup.exe') -Algorithm SHA256
