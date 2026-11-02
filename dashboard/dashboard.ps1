# 개발 워크스테이션 대시보드 생성기
# 실행할 때마다 Docker / Git 상태를 읽어 dashboard.html 을 만들고 브라우저로 연다.
$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8   # git/docker 의 한글 출력 깨짐 방지
$Root = Split-Path -Parent $PSScriptRoot
$Out  = Join-Path $PSScriptRoot 'dashboard.html'
function E($s) { [System.Net.WebUtility]::HtmlEncode([string]$s) }
function J($cmd) { & docker @cmd 2>$null | Where-Object { $_ -match '^\{' } | ForEach-Object { $_ | ConvertFrom-Json } }

# ---------- Docker 상태 ----------
$serverVer = (& docker version --format '{{.Server.Version}}' 2>$null)
$dockerUp  = [bool]$serverVer
$clientVer = (& docker --version 2>$null)

$containers = @(); $images = @(); $volumes = @(); $stats = @{}
if ($dockerUp) {
  # 과제용 웹 컨테이너가 꺼져 있으면 켜 둔다 (있을 때만)
  foreach ($n in 'my-web-8080','my-web-8081') {
    $st = (& docker inspect -f '{{.State.Running}}' $n 2>$null)
    if ($st -eq 'false') { & docker start $n *> $null }
  }
  Start-Sleep -Milliseconds 800
  $containers = @(J @('ps','-a','--format','{{json .}}'))
  $images     = @(J @('images','--format','{{json .}}'))
  $volumes    = @(J @('volume','ls','--format','{{json .}}'))
  foreach ($s in (J @('stats','--no-stream','--format','{{json .}}'))) { $stats[$s.Name] = $s }
}
$running = @($containers | Where-Object { $_.State -eq 'running' }).Count

# ---------- Git 상태 ----------
Push-Location $Root
$branch  = (& git rev-parse --abbrev-ref HEAD 2>$null)
$remote  = (& git remote get-url origin 2>$null)
$commits = @(& git log -6 --format='%h|%an|%ar|%s' 2>$null)
$dirty   = @(& git status --porcelain 2>$null).Count
Pop-Location
$repoWeb = ($remote -replace '\.git$','')

# ---------- HTML 조각 ----------
$rows = foreach ($c in $containers) {
  $isRun = $c.State -eq 'running'
  $dot = if ($isRun) { 'ok' } else { 'off' }
  $links = ''
  foreach ($m in [regex]::Matches([string]$c.Ports, '0\.0\.0\.0:(\d+)->')) {
    $p = $m.Groups[1].Value
    $links += "<a class='port' href='http://localhost:$p' target='_blank'>localhost:$p ↗</a>"
  }
  $cpu = ''; $mem = ''
  if ($stats.ContainsKey($c.Names)) { $cpu = $stats[$c.Names].CPUPerc; $mem = ($stats[$c.Names].MemUsage -split '/')[0].Trim() }
  "<tr><td><span class='dot $dot'></span>$(E $c.Names)</td><td class='mono'>$(E $c.Image)</td><td>$(E $c.Status)</td><td>$links</td><td class='mono'>$(E $cpu)</td><td class='mono'>$(E $mem)</td></tr>"
}
if (-not $rows) { $rows = "<tr><td colspan='6' class='empty'>컨테이너가 없습니다</td></tr>" }

$imgRows = foreach ($i in $images) { "<li><span class='mono'>$(E $i.Repository):$(E $i.Tag)</span><span class='muted'>$(E $i.Size)</span></li>" }
$volRows = foreach ($v in $volumes) { "<li><span class='mono'>$(E $v.Name)</span><span class='muted'>$(E $v.Driver)</span></li>" }
if (-not $imgRows) { $imgRows = "<li class='muted'>없음</li>" }
if (-not $volRows) { $volRows = "<li class='muted'>없음</li>" }

$commitRows = foreach ($l in $commits) {
  $p = $l -split '\|',4
  "<li><span class='mono hash'>$(E $p[0])</span><span class='msg'>$(E $p[3])</span><span class='muted'>$(E $p[1]) · $(E $p[2])</span></li>"
}

$check = @(
  @('터미널 기본 조작','#4-터미널-조작-로그'), @('권한 변경 (파일·디렉토리)','#5-권한-실습-파일-1-디렉토리-1'),
  @('Docker 설치·점검','#6-docker-설치-및-점검'), @('hello-world / ubuntu','#7-컨테이너-실행-실습'),
  @('attach vs exec','#7-컨테이너-실행-실습'), @('운영 명령','#8-docker-운영-명령'),
  @('Dockerfile 커스텀 이미지','#9-커스텀-이미지-dockerfile'), @('포트 매핑 2회','#10-포트-매핑-및-접속-2회'),
  @('바인드 마운트','#11-바인드-마운트-반영-호스트-변경-전후'), @('볼륨 영속성','#12-docker-볼륨-영속성-컨테이너-삭제-전후'),
  @('Git + VSCode 연동','#13-git-설정-및-github-연동'), @('트러블슈팅 2건+','#15-트러블슈팅')
)
$checkRows = foreach ($c in $check) { "<li><span class='tick'>✓</span><a href='$repoWeb#$($c[1].TrimStart('#'))' target='_blank'>$(E $c[0])</a></li>" }

$banner = if ($dockerUp) { '' } else { "<div class='banner'>Docker 엔진이 꺼져 있어요. <b>Docker Desktop</b>을 실행하고 Engine running 이 뜬 뒤 아이콘을 다시 클릭하세요.</div>" }
$engine = if ($dockerUp) { "<span class='pill ok'>Engine running</span>" } else { "<span class='pill bad'>Engine stopped</span>" }
$now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$dirtyTxt = if ($dirty -gt 0) { "커밋 안 된 변경 $dirty개" } else { '변경 없음 (깨끗함)' }

$html = @"
<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><title>Dev Workstation Dashboard</title>
<style>
:root{--bg:#f6f7f9;--card:#fff;--ink:#1d2430;--muted:#6b7380;--line:#e4e7ec;--ok:#16a34a;--off:#9aa1ab;--bad:#dc2626;--accent:#2563eb}
*{box-sizing:border-box}body{margin:0;font-family:"Segoe UI","Malgun Gothic",system-ui,sans-serif;background:var(--bg);color:var(--ink)}
header{display:flex;align-items:center;justify-content:space-between;padding:22px 32px;background:#0f172a;color:#fff}
header h1{margin:0;font-size:20px;font-weight:600}header .sub{color:#94a3b8;font-size:13px;margin-top:4px}
main{max-width:1180px;margin:24px auto;padding:0 24px;display:grid;gap:18px;grid-template-columns:repeat(4,1fr)}
.card{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:18px 20px}
.span2{grid-column:span 2}.span4{grid-column:span 4}
.kpi .n{font-size:30px;font-weight:700}.kpi .l{color:var(--muted);font-size:13px;margin-top:2px}
h2{font-size:14px;margin:0 0 12px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.04em}
table{width:100%;border-collapse:collapse;font-size:14px}th{text-align:left;color:var(--muted);font-weight:500;padding:6px 8px;border-bottom:1px solid var(--line)}
td{padding:9px 8px;border-bottom:1px solid var(--line)}tr:last-child td{border-bottom:0}
.mono{font-family:Consolas,"Cascadia Mono",monospace;font-size:13px}.muted{color:var(--muted);font-size:13px}.empty{color:var(--muted);text-align:center}
.dot{display:inline-block;width:9px;height:9px;border-radius:50%;margin-right:8px;vertical-align:middle}.dot.ok{background:var(--ok)}.dot.off{background:var(--off)}
.port{display:inline-block;margin-right:6px;padding:3px 9px;border-radius:999px;background:#eff6ff;color:var(--accent);text-decoration:none;font-size:13px}
.port:hover{background:#dbeafe}
ul{list-style:none;margin:0;padding:0}li{display:flex;justify-content:space-between;gap:10px;padding:7px 0;border-bottom:1px solid var(--line);font-size:14px}li:last-child{border-bottom:0}
.commits li{justify-content:flex-start}.hash{color:var(--accent)}.msg{flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.checks{columns:2}.checks li{justify-content:flex-start;break-inside:avoid;border:0;padding:5px 0}.tick{color:var(--ok);font-weight:700;margin-right:8px}
.checks a,.links a{color:var(--ink);text-decoration:none}.checks a:hover,.links a:hover{color:var(--accent)}
.pill{padding:4px 12px;border-radius:999px;font-size:13px;font-weight:600}.pill.ok{background:#dcfce7;color:#166534}.pill.bad{background:#fee2e2;color:#991b1b}
.banner{grid-column:span 4;background:#fef2f2;border:1px solid #fecaca;color:#991b1b;border-radius:12px;padding:14px 18px}
.links{display:flex;gap:10px;flex-wrap:wrap}.links a{border:1px solid var(--line);border-radius:8px;padding:8px 14px;background:#fff;font-size:14px}
footer{text-align:center;color:var(--muted);font-size:12px;margin:10px 0 30px}
</style></head><body>
<header><div><h1>🛠️ Dev Workstation Dashboard</h1><div class="sub">$(E $clientVer) · 갱신 $now</div></div>$engine</header>
<main>
$banner
<div class="card kpi"><div class="n">$running<span class="muted"> / $($containers.Count)</span></div><div class="l">실행 중 컨테이너</div></div>
<div class="card kpi"><div class="n">$($images.Count)</div><div class="l">이미지</div></div>
<div class="card kpi"><div class="n">$($volumes.Count)</div><div class="l">볼륨</div></div>
<div class="card kpi"><div class="n mono" style="font-size:22px;padding-top:6px">$(E $branch)</div><div class="l">$(E $dirtyTxt)</div></div>

<div class="card span4"><h2>컨테이너</h2>
<table><tr><th>이름</th><th>이미지</th><th>상태</th><th>접속</th><th>CPU</th><th>메모리</th></tr>
$($rows -join "`n")</table></div>

<div class="card span2"><h2>이미지</h2><ul>$($imgRows -join '')</ul></div>
<div class="card span2"><h2>볼륨</h2><ul>$($volRows -join '')</ul></div>

<div class="card span2"><h2>최근 커밋</h2><ul class="commits">$($commitRows -join '')</ul></div>
<div class="card span2"><h2>과제 체크리스트</h2><ul class="checks">$($checkRows -join '')</ul></div>

<div class="card span4"><h2>바로가기</h2><div class="links">
<a href="$repoWeb" target="_blank">GitHub 저장소</a>
<a href="$repoWeb/blob/main/README.md" target="_blank">README</a>
<a href="$repoWeb/blob/main/docs/evidence.md" target="_blank">수행 로그 (evidence)</a>
<a href="http://localhost:8080" target="_blank">localhost:8080</a>
<a href="http://localhost:8081" target="_blank">localhost:8081</a>
</div></div>
</main>
<footer>바탕화면 아이콘을 다시 클릭하면 최신 상태로 갱신됩니다.</footer>
</body></html>
"@

[System.IO.File]::WriteAllText($Out, $html, (New-Object System.Text.UTF8Encoding($false)))
Start-Process $Out
