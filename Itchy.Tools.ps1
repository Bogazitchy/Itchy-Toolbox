[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Precheck', 'InstallReport', 'UpdateSelf')]
    [string]$Action,

    [string]$InputPath,
    [string]$OutputPath,
    [string]$ToolboxPath
)

$ErrorActionPreference = 'SilentlyContinue'

function New-Page {
    param([string]$Title, [string]$Subtitle, [string]$Body, [string]$OutputPath)

    $style = @'
<style>
*{box-sizing:border-box}body{margin:0;background:#070a0d;color:#e8edf2;font-family:Segoe UI,Arial,sans-serif}
main{max-width:1180px;margin:0 auto;padding:30px 24px 48px}
header{border:1px solid #33424d;background:linear-gradient(135deg,#101820,#0a0f14);padding:24px;margin-bottom:16px;box-shadow:0 18px 55px rgba(0,0,0,.28)}
.brand{font:800 13px Consolas,monospace;color:#f8e98c;text-transform:uppercase;letter-spacing:.5px}
h1{margin:6px 0 8px;color:#fff}h2{color:#f8e98c;margin:0 0 12px}
.subtitle{color:#b6c1cb}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px;align-items:start}
section{min-width:0;border:1px solid #263847;background:#0d1218;padding:16px;overflow:visible}
table{width:100%;border-collapse:collapse;table-layout:fixed;font-size:12px}th{color:#69e8ff;background:#12202a;text-align:left}
th,td{border-bottom:1px solid #202b34;padding:7px 8px;vertical-align:top;white-space:normal;overflow-wrap:anywhere;word-break:break-word}
.ok{color:#00e676}.warn{color:#f8e98c}.bad{color:#ff6b6b}.muted{color:#93a2b0}
footer{color:#7f8c98;padding-top:18px;font-size:12px}
@media(max-width:900px){main{padding:18px 12px 34px}.grid{grid-template-columns:1fr}table{font-size:11px}th,td{padding:6px}}
</style>
'@
    $html = ConvertTo-Html -Title $Title -Head $style -Body "<main><header><div class='brand'>Itchy Toolbox</div><h1>$Title</h1><p class='subtitle'>$Subtitle</p></header>$Body<footer>Created by: M.Mert | $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</footer></main>"
    $folder = Split-Path -Parent $OutputPath
    if ($folder) { New-Item -ItemType Directory -Force -Path $folder | Out-Null }
    $html | Set-Content -Encoding UTF8 -Path $OutputPath
}

function New-Precheck {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $internet = Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    $os = Get-CimInstance Win32_OperatingSystem
    $cs = Get-CimInstance Win32_ComputerSystem
    $sysDrive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'"
    $license = cscript.exe //nologo "$env:windir\system32\slmgr.vbs" /xpr 2>$null | Out-String
    $pending = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'

    $rows = @(
        [pscustomobject]@{ Kontrol='Yönetici yetkisi'; Durum=if($isAdmin){'OK'}else{'Dikkat'}; Detay=if($isAdmin){'Yönetici olarak çalışıyor'}else{'Bazı işlemler için yönetici gerekir'} }
        [pscustomobject]@{ Kontrol='İnternet'; Durum=if($internet){'OK'}else{'Dikkat'}; Detay=if($internet){'Bağlantı var'}else{'Ping testi başarısız'} }
        [pscustomobject]@{ Kontrol='Winget'; Durum=if($winget){'OK'}else{'Eksik'}; Detay=if($winget){$winget.Source}else{'App Installer / winget kurulmalı'} }
        [pscustomobject]@{ Kontrol='Windows'; Durum='Bilgi'; Detay="$($os.Caption) $($os.OSArchitecture) build $($os.BuildNumber)" }
        [pscustomobject]@{ Kontrol='Lisans'; Durum='Bilgi'; Detay=($license.Trim() -replace "`r?`n",' ') }
        [pscustomobject]@{ Kontrol='RAM'; Durum='Bilgi'; Detay=('{0:N1} GB' -f ($cs.TotalPhysicalMemory/1GB)) }
        [pscustomobject]@{ Kontrol='Boş disk alanı'; Durum=if($sysDrive.FreeSpace -gt 10GB){'OK'}else{'Dikkat'}; Detay=('{0:N1} GB boş' -f ($sysDrive.FreeSpace/1GB)) }
        [pscustomobject]@{ Kontrol='Yeniden başlatma bekliyor'; Durum=if($pending){'Dikkat'}else{'OK'}; Detay=if($pending){'Bekleyen yeniden başlatma var'}else{'Bekleyen reboot görünmüyor'} }
    )
    $body = '<div class="grid"><section><h2>Ön Kontrol</h2>' + (($rows | ConvertTo-Html -Fragment) -replace '<td>OK</td>','<td class="ok">OK</td>' -replace '<td>Dikkat</td>','<td class="warn">Dikkat</td>' -replace '<td>Eksik</td>','<td class="bad">Eksik</td>') + '</section></div>'
    New-Page 'Itchy Ön Kontrol Raporu' 'Cihaz kuruluma ve bakıma hazır mı hızlıca kontrol eder.' $body $OutputPath
}

function New-InstallReport {
    $items = @()
    if ($InputPath -and (Test-Path $InputPath)) {
        $items = Import-Csv -Path $InputPath
    }
    if (-not $items) {
        $items = @([pscustomobject]@{ Tarih=(Get-Date); No='-'; Uygulama='Kayıt yok'; Paket='-'; Sonuc='Bilgi'; Not='Kurulum kaydı bulunamadı' })
    }
    $ok = @($items | Where-Object Sonuc -eq 'OK').Count
    $fail = @($items | Where-Object Sonuc -eq 'FAIL').Count
    $summary = @([pscustomobject]@{ Basarili=$ok; Basarisiz=$fail; Toplam=@($items).Count; Kaynak=$InputPath })
    $body = '<div class="grid"><section><h2>Özet</h2>' + ($summary | ConvertTo-Html -Fragment) + '</section><section><h2>Kurulum Kayıtları</h2>' + (($items | ConvertTo-Html -Fragment) -replace '<td>OK</td>','<td class="ok">OK</td>' -replace '<td>FAIL</td>','<td class="bad">FAIL</td>') + '</section></div>'
    New-Page 'Itchy Kurulum Raporu' 'Kurulum denemeleri, başarılar ve başarısızlar.' $body $OutputPath
}

function Update-Self {
    if (-not $ToolboxPath) { throw 'ToolboxPath gerekli' }
    $api = 'https://api.github.com/repos/Bogazitchy/Itchy-Toolbox/contents/Itchy%20ToolBox.cmd?ref=main'
    $info = Invoke-RestMethod -Headers @{'User-Agent'='ItchyToolbox'} -Uri $api
    $newText = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(($info.content -replace '\s','')))
    $backup = "$ToolboxPath.bak"
    Copy-Item -LiteralPath $ToolboxPath -Destination $backup -Force
    [IO.File]::WriteAllText($ToolboxPath, ($newText -replace "`r?`n","`r`n"), [Text.UTF8Encoding]::new($false))
    "Güncellendi. Yedek: $backup"
}

switch ($Action) {
    'Precheck' { New-Precheck }
    'InstallReport' { New-InstallReport }
    'UpdateSelf' { Update-Self }
}
