$ErrorActionPreference = "SilentlyContinue"

$url = "https://wayground.com/join?gc=371410"
$minutes = 13

$edge = @(
  "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $edge) { throw "Microsoft Edge not found." }

try {
  & taskkill /F /IM explorer.exe | Out-Null

  Start-Process -FilePath $edge -ArgumentList @(
    "--kiosk", $url,
    "--edge-kiosk-type=fullscreen",
    "--no-first-run"
  ) | Out-Null

  Start-Sleep -Seconds ([int]([TimeSpan]::FromMinutes($minutes)).TotalSeconds)
}
finally {
  & taskkill /F /IM msedge.exe | Out-Null
  Start-Process explorer.exe | Out-Null
}
