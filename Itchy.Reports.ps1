[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('System', 'Network')]
    [string]$Type,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$ErrorActionPreference = 'SilentlyContinue'

function Convert-ToFragment {
    param(
        [string]$Title,
        [object]$Data,
        [string]$Note
    )

    $content = ''
    if ($null -ne $Data) {
        $items = @($Data)
        if ($items.Count -gt 0) {
            $content = $items | ConvertTo-Html -Fragment
        }
    }

    if ([string]::IsNullOrWhiteSpace($content)) {
        $content = '<p class="empty">Bilgi okunamadı veya kayıt bulunamadı.</p>'
    }

    if (-not [string]::IsNullOrWhiteSpace($Note)) {
        $content = '<p class="note">' + [Net.WebUtility]::HtmlEncode($Note) + '</p>' + $content
    }

    return '<section><h2>' + [Net.WebUtility]::HtmlEncode($Title) + '</h2>' + $content + '</section>'
}

function Convert-ToPreBlock {
    param(
        [string]$Title,
        [string]$Text
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        $Text = 'Bilgi okunamadı.'
    }

    return '<section><h2>' + [Net.WebUtility]::HtmlEncode($Title) + '</h2><pre>' +
        [Net.WebUtility]::HtmlEncode($Text.Trim()) + '</pre></section>'
}

function Format-Size {
    param([double]$Bytes)

    if ($Bytes -le 0) {
        return '-'
    }

    if ($Bytes -ge 1TB) {
        return ('{0:N2} TB' -f ($Bytes / 1TB))
    }

    if ($Bytes -ge 1GB) {
        return ('{0:N2} GB' -f ($Bytes / 1GB))
    }

    if ($Bytes -ge 1MB) {
        return ('{0:N2} MB' -f ($Bytes / 1MB))
    }

    return ('{0:N0} B' -f $Bytes)
}

function Get-AdminState {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-StatusText {
    param([string]$Value)

    switch ($Value) {
        'Up' { return 'Aktif' }
        'Down' { return 'Kapalı' }
        'Running' { return 'Çalışıyor' }
        'Stopped' { return 'Durdu' }
        'Connected' { return 'Bağlı' }
        'Disconnected' { return 'Bağlı değil' }
        'Public' { return 'Genel' }
        'Private' { return 'Özel' }
        'DomainAuthenticated' { return 'Etki alanı' }
        'Internet' { return 'Internet' }
        'LocalNetwork' { return 'Yerel ağ' }
        'NoTraffic' { return 'Trafik yok' }
        'Success' { return 'Başarılı' }
        default { return $Value }
    }
}

function New-ReportPage {
    param(
        [string]$Title,
        [string]$Subtitle,
        [string[]]$Sections
    )

    $style = @'
<style>
*{box-sizing:border-box}
body{margin:0;background:#080b0f;color:#e8edf2;font-family:Segoe UI,Arial,sans-serif;line-height:1.45}
main{max-width:1280px;margin:0 auto;padding:34px 28px 52px}
header{border:1px solid #2a3540;background:linear-gradient(135deg,#121a22,#0d1117);padding:28px;margin-bottom:18px}
.brand{color:#00e676;font:700 13px Consolas,monospace;letter-spacing:0;text-transform:uppercase}
h1{font-size:34px;line-height:1.15;margin:8px 0 10px;color:#fff}
h2{font-size:18px;margin:0 0 14px;color:#f8e98c}
p{margin:0 0 12px}
.subtitle{max-width:760px;color:#b6c1cb}
.meta{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:10px;margin-top:18px}
.meta div{border:1px solid #25313b;background:#0b1016;padding:11px 13px;color:#b6c1cb}
.meta strong{display:block;color:#fff;font-size:13px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(430px,1fr));gap:14px}
section{min-width:0;border:1px solid #26323d;background:#0d1218;padding:18px;overflow:auto}
table{width:max-content;min-width:100%;border-collapse:collapse;font-size:13px;color:#e8edf2}
th{position:sticky;top:0;background:#131e27;color:#00e676;text-align:left;font-weight:600}
th,td{padding:8px 9px;border-bottom:1px solid #202b34;vertical-align:top;word-break:normal}
th{white-space:nowrap}
td{min-width:84px;overflow-wrap:anywhere}
td:first-child{min-width:110px}
tr:nth-child(even) td{background:#0a0f14}
pre{margin:0;background:#070a0d;border:1px solid #1f2932;color:#dbe5ee;padding:14px;white-space:pre-wrap;word-break:break-word;font:12px Consolas,monospace}
.note{border-left:3px solid #00b8ff;background:#081821;color:#c6e9f7;padding:9px 11px}
.empty{color:#93a2b0}
footer{color:#7f8c98;padding:18px 2px 0;font-size:12px}
@media(max-width:640px){main{padding:18px 12px 34px}.grid{grid-template-columns:1fr}h1{font-size:26px}}
</style>
'@

    $generated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $admin = if (Get-AdminState) { 'Evet' } else { 'Hayır' }
    $body = @(
        '<main>'
        '<header>'
        '<div class="brand">Itchy Toolbox</div>'
        '<h1>' + [Net.WebUtility]::HtmlEncode($Title) + '</h1>'
        '<p class="subtitle">' + [Net.WebUtility]::HtmlEncode($Subtitle) + '</p>'
        '<div class="meta">'
        '<div><strong>Oluşturma zamanı</strong>' + [Net.WebUtility]::HtmlEncode($generated) + '</div>'
        '<div><strong>Bilgisayar</strong>' + [Net.WebUtility]::HtmlEncode($env:COMPUTERNAME) + '</div>'
        '<div><strong>Kullanıcı</strong>' + [Net.WebUtility]::HtmlEncode($env:USERNAME) + '</div>'
        '<div><strong>Yönetici</strong>' + $admin + '</div>'
        '</div>'
        '</header>'
        '<div class="grid">'
        ($Sections -join [Environment]::NewLine)
        '</div>'
        '<footer>Created by: M.Mert | Itchy Toolbox raporu</footer>'
        '</main>'
    ) -join [Environment]::NewLine

    $html = ConvertTo-Html -Title $Title -Head $style -Body $body
    $folder = Split-Path -Parent $OutputPath
    if (-not [string]::IsNullOrWhiteSpace($folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    $html | Set-Content -Path $OutputPath -Encoding UTF8
}

function New-SystemReport {
    $os = Get-CimInstance Win32_OperatingSystem
    $computer = Get-CimInstance Win32_ComputerSystem
    $board = Get-CimInstance Win32_BaseBoard
    $bios = Get-CimInstance Win32_BIOS
    $cpu = Get-CimInstance Win32_Processor
    $ram = Get-CimInstance Win32_PhysicalMemory
    $disks = Get-CimInstance Win32_DiskDrive
    $volumes = Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3'
    $gpus = Get-CimInstance Win32_VideoController
    $updates = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 15
    $services = Get-Service | Group-Object Status | Sort-Object Name
    $boot = if ($os.LastBootUpTime) { $os.LastBootUpTime } else { '-' }
    $uptime = if ($os.LastBootUpTime) { (New-TimeSpan -Start $os.LastBootUpTime -End (Get-Date)).ToString() } else { '-' }
    $secureBoot = try { Confirm-SecureBootUEFI } catch { 'Okunamadı' }

    $overview = @(
        [pscustomobject]@{ Alan = 'Windows'; Bilgi = ($os.Caption + ' ' + $os.OSArchitecture) }
        [pscustomobject]@{ Alan = 'Sürüm'; Bilgi = $os.Version }
        [pscustomobject]@{ Alan = 'Build'; Bilgi = $os.BuildNumber }
        [pscustomobject]@{ Alan = 'Kurulum tarihi'; Bilgi = $os.InstallDate }
        [pscustomobject]@{ Alan = 'Son açılış'; Bilgi = $boot }
        [pscustomobject]@{ Alan = 'Çalışma süresi'; Bilgi = $uptime }
        [pscustomobject]@{ Alan = 'Saat dilimi'; Bilgi = (Get-TimeZone).DisplayName }
        [pscustomobject]@{ Alan = 'Secure Boot'; Bilgi = $secureBoot }
    )

    $device = @(
        [pscustomobject]@{ Alan = 'Üretici'; Bilgi = $computer.Manufacturer }
        [pscustomobject]@{ Alan = 'Model'; Bilgi = $computer.Model }
        [pscustomobject]@{ Alan = 'Anakart'; Bilgi = ($board.Manufacturer + ' ' + $board.Product) }
        [pscustomobject]@{ Alan = 'BIOS'; Bilgi = $bios.SMBIOSBIOSVersion }
        [pscustomobject]@{ Alan = 'BIOS tarihi'; Bilgi = $bios.ReleaseDate }
        [pscustomobject]@{ Alan = 'Toplam RAM'; Bilgi = Format-Size $computer.TotalPhysicalMemory }
    )

    $processors = $cpu | Select-Object `
        @{Name = 'İşlemci'; Expression = { $_.Name }},
        @{Name = 'Üretici'; Expression = { $_.Manufacturer }},
        @{Name = 'Çekirdek'; Expression = { $_.NumberOfCores }},
        @{Name = 'Mantıksal işlemci'; Expression = { $_.NumberOfLogicalProcessors }},
        @{Name = 'En yüksek frekans MHz'; Expression = { $_.MaxClockSpeed }},
        @{Name = 'L2 Cache KB'; Expression = { $_.L2CacheSize }},
        @{Name = 'L3 Cache KB'; Expression = { $_.L3CacheSize }}
    $memory = $ram | Select-Object `
        @{Name = 'Üretici'; Expression = { $_.Manufacturer }},
        @{Name = 'Parça numarası'; Expression = { $_.PartNumber }},
        @{Name = 'Banka'; Expression = { $_.BankLabel }},
        @{Name = 'Slot'; Expression = { $_.DeviceLocator }},
        @{Name = 'Hız MHz'; Expression = { $_.Speed }},
        @{Name = 'Yapılandırılmış hız MHz'; Expression = { $_.ConfiguredClockSpeed }},
        @{Name = 'Kapasite'; Expression = { Format-Size $_.Capacity }}
    $storage = $disks | Select-Object `
        @{Name = 'Model'; Expression = { $_.Model }},
        @{Name = 'Arayüz'; Expression = { $_.InterfaceType }},
        @{Name = 'Ortam türü'; Expression = { $_.MediaType }},
        @{Name = 'Seri numarası'; Expression = { $_.SerialNumber }},
        @{Name = 'Kapasite'; Expression = { Format-Size $_.Size }}
    $partitions = $volumes | Select-Object `
        @{Name = 'Sürücü'; Expression = { $_.DeviceID }},
        @{Name = 'Birim adı'; Expression = { $_.VolumeName }},
        @{Name = 'Dosya sistemi'; Expression = { $_.FileSystem }},
        @{Name = 'Boyut'; Expression = { Format-Size $_.Size }},
        @{Name = 'Boş alan'; Expression = { Format-Size $_.FreeSpace }},
        @{Name = 'Doluluk'; Expression = { if ($_.Size) { '{0:N1}%' -f ((($_.Size - $_.FreeSpace) / $_.Size) * 100) } else { '-' } }}
    $graphics = $gpus | Select-Object `
        @{Name = 'Ekran kartı'; Expression = { $_.Name }},
        @{Name = 'Sürücü sürümü'; Expression = { $_.DriverVersion }},
        @{Name = 'Sürücü tarihi'; Expression = { $_.DriverDate }},
        @{Name = 'Video işlemcisi'; Expression = { $_.VideoProcessor }},
        @{Name = 'VRAM'; Expression = { Format-Size $_.AdapterRAM }}
    $serviceSummary = $services | Select-Object @{Name = 'Durum'; Expression = { Get-StatusText $_.Name }}, @{Name = 'Adet'; Expression = { $_.Count }}
    $updateTable = $updates | Select-Object `
        @{Name = 'Güncelleme'; Expression = { $_.HotFixID }},
        @{Name = 'Açıklama'; Expression = { $_.Description }},
        @{Name = 'Yükleyen'; Expression = { $_.InstalledBy }},
        @{Name = 'Kurulum tarihi'; Expression = { $_.InstalledOn }}

    $sections = @(
        Convert-ToFragment 'Windows Özeti' $overview 'İşletim sistemi, zaman ve açılış bilgileri.'
        Convert-ToFragment 'Cihaz Özeti' $device 'Anakart, BIOS ve fiziksel sistem bilgileri.'
        Convert-ToFragment 'İşlemci' $processors ''
        Convert-ToFragment 'RAM Modülleri' $memory ''
        Convert-ToFragment 'Fiziksel Diskler' $storage ''
        Convert-ToFragment 'Disk Bölümleri' $partitions ''
        Convert-ToFragment 'Ekran Kartları' $graphics ''
        Convert-ToFragment 'Hizmet Durumu Özeti' $serviceSummary ''
        Convert-ToFragment 'Son Windows Güncellemeleri' $updateTable 'En yeni 15 hotfix kaydı listelenir.'
    )

    New-ReportPage 'Sistem Raporu' 'Donanım, Windows sürümü, disk, RAM, ekran kartı ve bakım kayıtlarını tek sayfada toplar.' $sections
}

function New-NetworkReport {
    $adapter = Get-NetAdapter
    $profiles = Get-NetConnectionProfile
    $ipConfig = Get-NetIPConfiguration
    $ipAddresses = Get-NetIPAddress | Where-Object { $_.IPAddress -notlike 'fe80:*' }
    $dns = Get-DnsClientServerAddress
    $routes = Get-NetRoute | Where-Object { $_.DestinationPrefix -eq '0.0.0.0/0' -or $_.DestinationPrefix -eq '::/0' }
    $wifiProfiles = netsh wlan show profiles 2>$null
    $testHosts = @('google.com', 'youtube.com', 'reddit.com', 'cloudflare.com')
    $tests = foreach ($hostName in $testHosts) {
        $pingMs = '-'
        $dnsMs = '-'
        $pingStatus = 'Hata'
        try {
            $ping = New-Object Net.NetworkInformation.Ping
            $reply = $ping.Send($hostName, 1200)
            $pingStatus = Get-StatusText ([string]$reply.Status)
            if ($reply.Status -eq 'Success') {
                $pingMs = [string]$reply.RoundtripTime
            }
        } catch {}

        try {
            $watch = [Diagnostics.Stopwatch]::StartNew()
            [void][Net.Dns]::GetHostAddresses($hostName)
            $watch.Stop()
            $dnsMs = [string][math]::Round($watch.Elapsed.TotalMilliseconds, 1)
        } catch {}

        [pscustomobject]@{
            Hedef = $hostName
            'Ping durumu' = $pingStatus
            'Ping ms' = $pingMs
            'DNS ms' = $dnsMs
        }
    }

    $adapterTable = $adapter | Select-Object `
        @{Name = 'Bağdaştırıcı'; Expression = { $_.Name }},
        @{Name = 'Açıklama'; Expression = { $_.InterfaceDescription }},
        @{Name = 'Durum'; Expression = { Get-StatusText $_.Status }},
        @{Name = 'Bağlantı hızı'; Expression = { $_.LinkSpeed }},
        @{Name = 'MAC adresi'; Expression = { $_.MacAddress }},
        @{Name = 'Sürücü bilgisi'; Expression = { $_.DriverInformation }}
    $profileTable = $profiles | Select-Object `
        @{Name = 'Profil'; Expression = { $_.Name }},
        @{Name = 'Bağdaştırıcı'; Expression = { $_.InterfaceAlias }},
        @{Name = 'Ağ türü'; Expression = { Get-StatusText $_.NetworkCategory }},
        @{Name = 'IPv4 bağlantısı'; Expression = { Get-StatusText $_.IPv4Connectivity }},
        @{Name = 'IPv6 bağlantısı'; Expression = { Get-StatusText $_.IPv6Connectivity }}
    $ipTable = $ipConfig | Select-Object @{Name = 'Bağdaştırıcı'; Expression = { $_.InterfaceAlias }},
        @{Name = 'IPv4'; Expression = { ($_.IPv4Address.IPAddress -join ', ') }},
        @{Name = 'IPv6'; Expression = { ($_.IPv6Address.IPAddress -join ', ') }},
        @{Name = 'Varsayılan geçit'; Expression = { ($_.IPv4DefaultGateway.NextHop -join ', ') }},
        @{Name = 'DNS'; Expression = { ($_.DNSServer.ServerAddresses -join ', ') }}
    $addressTable = $ipAddresses | Select-Object `
        @{Name = 'Bağdaştırıcı'; Expression = { $_.InterfaceAlias }},
        @{Name = 'Adres ailesi'; Expression = { $_.AddressFamily }},
        @{Name = 'IP adresi'; Expression = { $_.IPAddress }},
        @{Name = 'Prefix uzunluğu'; Expression = { $_.PrefixLength }},
        @{Name = 'Tür'; Expression = { $_.Type }}
    $dnsTable = $dns | Select-Object `
        @{Name = 'Bağdaştırıcı'; Expression = { $_.InterfaceAlias }},
        @{Name = 'Adres ailesi'; Expression = { $_.AddressFamily }},
        @{Name = 'DNS sunucuları'; Expression = { $_.ServerAddresses -join ', ' }}
    $routeTable = $routes | Select-Object `
        @{Name = 'Bağdaştırıcı'; Expression = { $_.InterfaceAlias }},
        @{Name = 'Adres ailesi'; Expression = { $_.AddressFamily }},
        @{Name = 'Hedef prefix'; Expression = { $_.DestinationPrefix }},
        @{Name = 'Sonraki atlama'; Expression = { $_.NextHop }},
        @{Name = 'Rota metriği'; Expression = { $_.RouteMetric }}
    $ipconfigText = ipconfig /all | Out-String

    $sections = @(
        Convert-ToFragment 'Bağlantı Profilleri' $profileTable ''
        Convert-ToFragment 'Ağ Bağdaştırıcıları' $adapterTable 'Sürücü, durum, hız ve MAC bilgileri.'
        Convert-ToFragment 'IP Yapılandırması' $ipTable ''
        Convert-ToFragment 'IP Adresleri' $addressTable ''
        Convert-ToFragment 'DNS Sunucuları' $dnsTable ''
        Convert-ToFragment 'Varsayılan Rotalar' $routeTable ''
        Convert-ToFragment 'Ping ve DNS Testleri' $tests 'Rapor oluşturulurken yapılan hızlı erişim testleri.'
        Convert-ToPreBlock 'Kayıtlı WiFi Profil Adları' ($wifiProfiles | Out-String)
        Convert-ToPreBlock 'ipconfig /all' $ipconfigText
    )

    New-ReportPage 'Ağ Raporu' 'Bağdaştırıcı, IP, DNS, rota, WiFi profil adı ve bağlantı testlerini tek sayfada toplar.' $sections
}

if ($Type -eq 'System') {
    New-SystemReport
} else {
    New-NetworkReport
}
