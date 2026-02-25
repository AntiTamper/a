$ErrorActionPreference = "SilentlyContinue"

$u = "https://wayground.com/join?gc=371410"
$minutes = 15

$edge = @(
  "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $edge) { throw "Microsoft Edge not found." }

function Start-EdgeKiosk {
  Start-Process -FilePath $edge -ArgumentList @(
    "--kiosk", $u,
    "--edge-kiosk-type=fullscreen",
    "--no-first-run",
    "--disable-features=TranslateUI"
  ) | Out-Null
}

try {
  Stop-Process -Name explorer -Force | Out-Null

  Start-EdgeKiosk

  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  $deadline = [TimeSpan]::FromMinutes($minutes)

  while ($sw.Elapsed -lt $deadline) {
    $p = Get-Process -Name msedge -ErrorAction SilentlyContinue
    if (-not $p) { Start-EdgeKiosk }
    Start-Sleep -Milliseconds 500
  }
}
finally {
  Get-Process -Name msedge -ErrorAction SilentlyContinue | Stop-Process -Force | Out-Null
  Start-Process explorer.exe | Out-Null
}
