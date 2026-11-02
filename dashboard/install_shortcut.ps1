# 바탕화면에 "Dev Dashboard" 바로가기를 만든다 (한 번만 실행)
$ps1     = Join-Path $PSScriptRoot 'dashboard.ps1'
$desktop = [Environment]::GetFolderPath('Desktop')   # OneDrive 바탕화면도 자동 인식
$lnk     = Join-Path $desktop 'Dev Dashboard.lnk'

$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($lnk)
$sc.TargetPath       = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$sc.Arguments        = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ps1`""
$sc.WorkingDirectory = $PSScriptRoot
$dockerExe = "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
$sc.IconLocation = if (Test-Path $dockerExe) { "$dockerExe,0" } else { "$env:SystemRoot\System32\shell32.dll,21" }
$sc.Description      = 'Docker / Git 상태 대시보드'
$sc.Save()
Write-Host "바탕화면에 바로가기를 만들었습니다: $lnk"
