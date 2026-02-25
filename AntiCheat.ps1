$ErrorActionPreference="SilentlyContinue"

$url="https://wayground.com/join?gc=371410"
$minutes=13
$regPath="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$edge=@(
 "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
 "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)|?{Test-Path $_}|select -First 1

if(-not $edge){exit}

$orig=(Get-ItemProperty -Path $regPath -Name AutoRestartShell -ErrorAction SilentlyContinue).AutoRestartShell
if($orig -ne 0){Set-ItemProperty -Path $regPath -Name AutoRestartShell -Value 0}

try{
 & taskkill /F /IM explorer.exe
 Start-Process $edge "--kiosk $url --edge-kiosk-type=fullscreen --no-first-run"
 Start-Sleep -Seconds ($minutes*60)
}
finally{
 & taskkill /F /IM msedge.exe
 if($orig -ne $null){Set-ItemProperty -Path $regPath -Name AutoRestartShell -Value $orig}else{Remove-ItemProperty -Path $regPath -Name AutoRestartShell -ErrorAction SilentlyContinue}
 Start-Process explorer.exe
}
