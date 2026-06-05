# Itchy Toolbox

Itchy Toolbox, Windows kurulum ve teknik servis islemlerini tek bir CMD arayuzunde toplayan hafif bir sistem aracidir.

Program; uygulama kurulumu, Windows onarim komutlari, hizmet ve ozellik yonetimi, ag kontrolleri, sistem raporlama, lisans goruntuleme ve kayitli WiFi bilgilerini okuma gibi sik kullanilan islemleri menuler halinde sunar.

GitHub: [Bogazitchy/Itchy-Toolbox](https://github.com/Bogazitchy/Itchy-Toolbox)

## Ozellikler

### Uygulama Yukleyici

- Kategorilere ayrilmis uygulama listesi
- Coklu secim ile toplu kurulum
- `winget` uzerinden sessiz kurulum destegi
- Ozel kurulum isaretli uygulamalar
- Standart teknik servis uygulamalarina hizli erisim
- Sorunlu `winget` paketleri icin ozel indirme/kurulum akisi
- Kurulum logu, basarisizlari tekrar deneme ve HTML kurulum raporu

Mevcut uygulama kategorileri:

- Mesajlasma
- Oyun Kutuphanesi
- Tarayici
- Multimedya
- Video-Ses Oynatici
- Indirme Araclari
- Belgeler
- Gelistirme
- Donanim
- Disk-Depolama
- USB-ISO
- Backup-Recovery
- Uzak Destek
- Guvenlik Tarama
- Runtime
- Temizlik
- Diger
- Uninstaller
- Itchy Programlari

### Kurulum Profilleri

Hazir profiller tek secimle sik kullanilan uygulama setlerini kurar:

- Standart cihaz
- Teknik servis
- Oyun ve medya
- Gelistirici

Bu menude ayrica:

- Kurulu `winget` uygulama listesini JSON olarak disari aktarma
- Daha once aktarilmis `winget` JSON listesinden toplu kurulum

secenekleri bulunur.

### Ozel Kurulum Destegi

Bazi uygulamalar `winget` manifest hatasi, hash uyusmazligi, Microsoft Store kaynak farki veya yonetici oturumu kisiti nedeniyle standart kurulumda sorun cikarabilir. Bu uygulamalar toolbox icinde ozel akisa alinmistir:

- WhatsApp: Microsoft Store kaynak ID'si ile kurulur.
- CrystalDiskInfo: `winget` hash sorunu yasandiginda resmi indirme kaynagindan baslatilir.
- Spotify: Yonetici oturumunda normal kurulum reddedildigi icin ozel makine kurulumu denenir.
- DMDE: Resmi sitesinden indirilip cikarilir ve calistirilir.
- RustDesk: GitHub son surum dosyasindan indirilir.
- Malwarebytes: `winget` 403 hatasi yerine resmi Malwarebytes indirme adresi kullanilir.
- IObit Unlocker: `winget` hash sorunu yerine resmi indirme adresi kullanilir.
- Java Uninstaller: Oracle Java Uninstall Tool indirilip baslatilir.
- Itchy YouTube Downloader: [Bogazitchy/Itchy-YouTube-Downloader](https://github.com/Bogazitchy/Itchy-YouTube-Downloader) reposunun en guncel release setup dosyasi indirilip baslatilir.
- Itchy Backup: [Bogazitchy/Itchy-Backup](https://github.com/Bogazitchy/Itchy-Backup) reposunun en guncel release setup dosyasi indirilip baslatilir.

Bu uygulamalar uygulama listesinde `*` ile isaretlenir.

### Windows Yonetimi

- Hizmet Yonetimi
- Ozellik Yonetimi
- Windows Onarim
- PC zaman ayarli kapatma
- Lisans Yonetimi
- Sistem Hakkinda
- Kayitli WiFi Bilgileri

### Windows Onarim

Windows Onarim menusu su islemleri toplar:

- CHKDSK online disk tarama
- DISM ve SFC sistem dosyasi onarimi
- Disk Cleanup
- Event Viewer
- Task Manager
- Windows Memory Diagnostic
- Sistem geri yukleme noktasi olusturma
- Windows Update bilesenlerini sifirlama
- Ag onarim komutlari

### Ag ve DNS

Ping Olcer / DNS Degistirici menusu:

- Tanimli sitelerin ping ve DNS surelerini anlik gosterir
- Girilen alan adi icin ping olcer
- Girilen alan adi icin DNS sorgu suresini olcer
- Cloudflare, AdGuard, Quad9, ControlD ve Google DNS sunucularini test eder
- Aktif ag bagdastiricilarinda DNS degistirebilir
- DNS ayarlarini otomatik moda alabilir

Ag Onarim / Rapor menusu:

- DNS onbellegini temizler
- Winsock ve IP reset komutlarini calistirir
- IP ve bagdastirici bilgisini gosterir
- Masaustune detayli HTML sistem raporu olusturur
- Masaustune detayli HTML ag raporu olusturur

HTML raporlar koyu temali, tablolu ve teknik servis kontrolune uygun okunabilir bir formatta uretilir.

### On Kontrol

On Kontrol menusu cihaz kuruluma hazir mi hizlica denetler:

- Yonetici yetkisi
- Internet testi
- Winget varligi
- Windows surumu
- Lisans durumu
- RAM ve bos disk alani
- Bekleyen yeniden baslatma kontrolu

Sonuc ekrana yazdirilabilir veya `Itchy-Precheck-Report.html` olarak kaydedilebilir.

### Kurulum Sonrasi Kontrol

- Son kurulum HTML raporu
- Basarisiz kurulumlari tekrar deneme
- Winget kurulu uygulama listesi
- Windows Update
- Aygit Yoneticisi
- Sistem HTML raporu

### Surucu Yardimci

Riskli otomatik surucu kurulumlari yerine guvenli kisayollar sunar:

- Aygit Yoneticisi
- Windows Update
- NVIDIA, AMD ve Intel surucu sayfalari
- Anakart/CPU bilgisi icin sistem raporu
- DDU kurulumu

### Windows Ayarlari

Aktivasyon, Windows Update, varsayilan uygulamalar, ag, depolama, baslangic uygulamalari, guc secenekleri, uzak masaustu, Bluetooth ve yazici ayarlarina hizli erisim saglar.

### Bakim Profilleri

- Hafif bakim: DNS temizleme, temp temizleme ve kurulum raporu
- Derin bakim: geri yukleme noktasi, DISM/SFC ve sistem raporu
- Ag bakim: DNS/Winsock/IP onarimi
- Cihaz teslim raporu: on kontrol, sistem raporu, ag raporu ve kurulum raporu

### Log / Ayar / Guncelleme

- Son kurulum logunu gosterir
- Log klasorunu acar
- Rapor klasoru ayari yapar
- Tema ayari yapar
- Splash ekranini acip kapatir
- Toolbox'i GitHub `main` uzerinden gunceller

### Yedekleme ve Geri Yukleme

- Sistem geri yukleme noktasi olusturma
- Sistem Geri Yukleme aracini acma
- Dosya Gecmisi aracini acma
- Windows Yedekleme ayarlarini acma
- `winget` uygulama listesini disari aktarma
- `winget` listesinden uygulama kurma

## Gereksinimler

- Windows 10 veya Windows 11
- CMD ve PowerShell
- Uygulama kurulumlari icin Windows Package Manager (`winget`)
- Microsoft Store kaynakli paketler icin `msstore` winget kaynagi
- Bazi islemler icin yonetici izni

`winget` bulunmazsa Uygulama Yukleyici ekranda uyari verir. Bu durumda Microsoft App Installer / Windows Package Manager kurulumu kontrol edilmelidir.

## Kullanim

1. `Itchy ToolBox.cmd` dosyasini calistirin.
2. Ana menuden numara girerek istediginiz bolume gecin.
3. Alt menulerde:
   - `x` geri doner
   - `q` programdan cikar
4. Uygulama Yukleyici icinde birden fazla uygulama secmek icin numaralari virgul ile girin.

Ornek:

```text
1,9,28,40
```

## Yonetici Yetkisi

Program yonetici izni olmadan da acilir. Ancak su islemlerde yonetici yetkisi gerekebilir:

- Hizmet baslatma veya kapatma
- Windows ozelliklerini degistirme
- DNS degistirme
- DISM, SFC, CHKDSK ve Windows Update sifirlama
- Geri yukleme noktasi olusturma
- Lisans islemleri

Ana menudeki `Yonetici Olarak Yeniden Baslat` secenegi ile araci yukseltilmis izinle tekrar acabilirsiniz.

## Olusturulan Dosyalar

Program bazi seceneklerde masaustune dosya olusturabilir:

- `Itchy-Winget-Apps.json`
- `Itchy-Precheck-Report.html`
- `Itchy-Install-Report.html`
- `Itchy-System-Report.html`
- `Itchy-Network-Report.html`
- `Itchy-Toolbox-Data\Logs\Itchy-Toolbox.log`
- `Itchy-Toolbox-Data\last-install-log.csv`

## Guvenli Kullanim Notlari

- Onarim ve reset komutlarini calistirmadan once kullanicinin islerini kaydettiginden emin olun.
- Ag reset islemlerinden sonra yeniden baslatma gerekebilir.
- Windows Update sifirlama islemi guncelleme onbellegini yeniden olusturur.
- Lisans menusu yalnizca gecerli Windows ve Office urun anahtarlari icin kullanilmalidir.
- Kayitli WiFi sifreleri sadece yetkili olunan cihazlarda goruntulenmelidir.

## Dosyalar

- `Itchy ToolBox.cmd`: Ana program
- `Itchy.Reports.ps1`: HTML rapor uretici
- `Itchy.Tools.ps1`: On kontrol, kurulum raporu ve self-update yardimcisi
- `README.md`: Proje aciklamasi ve kullanim notlari

Depoda yalnizca aktif kullanilan dosyalar tutulmalidir. Yerel deneme, yedek veya gecici dosyalar repo disinda birakilabilir.

## Surum

Guncel toolbox surumu: `0.4`

## Gelistirici

Created by: M.Mert
