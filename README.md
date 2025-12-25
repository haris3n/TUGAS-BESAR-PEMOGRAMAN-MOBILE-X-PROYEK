# 🏃 HealthTrack - Personal Activity Tracker

**HealthTrack** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memantau aktivitas kesehatan harian (Air, Langkah, Olahraga). 
Aplikasi ini terintegrasi dengan backend Laravel melalui REST API menggunakan tunneling Ngrok untuk akses publik yang aman.

---

## 🛠️ Tech Stack & Dependencies

### Core Technologies
* **Frontend:** Flutter (Dart SDK >= 3.0)
* **Backend:** Laravel (REST API)
* **Database:** MySQL
* **Tunneling:** Ngrok (Untuk akses Public URL)

### Dependencies (Libraries)
Daftar paket utama yang digunakan dalam proyek ini:
* **`provider`**: Mengelola *state* aplikasi (State Management) secara reaktif agar UI sinkron dengan data harian.
* **`dio`**: Library HTTP client untuk menangani permintaan API (GET/POST) ke backend secara asinkron.
* **`shared_preferences`**: Menyimpan data lokal secara persisten seperti Token Otentikasi dan Nama Pengguna.
* **`intl`**: Digunakan untuk pemformatan tanggal dan waktu pada log aktivitas kesehatan.

---

## 🚀 Panduan Setup & Cara Menjalankan (Run)

### 1. Persiapan Backend (Laravel)
1.  Buka terminal di folder backend Laravel Anda.
2.  Jalankan perintah:
    ```bash
    php artisan serve
    ```
    *(Secara default berjalan di http://127.0.0.1:8000)*

### 2. Aktivasi Ngrok (Tunneling)
Karena menggunakan HP fisik atau emulator, Anda perlu membuat URL publik agar API lokal bisa diakses:
1.  Buka terminal baru, jalankan:
    ```bash
    ngrok http 8000
    ```
2.  Salin URL `Forwarding` yang muncul (contoh: `https://abcd-123.ngrok-free.app`).

### 3. Konfigurasi API di Flutter
Buka file `lib/core/constants/api_url.dart` dan sesuaikan `baseUrl` dengan URL Ngrok Anda:
```dart
class ApiUrl {
  // Pastikan URL diakhiri dengan /api
  static const String baseUrl = '[https://abcd-123.ngrok-free.app/api](https://abcd-123.ngrok-free.app/api)'; 
}
### 4. Cara Menjalankan Aplikasi
       ```bash
       flutter pub get
       flutter run
      ```
---

## 📦 Cara Build APK (Release)
Untuk menghasilkan file instalasi Android (.apk) versi rilis yang siap dikumpulkan:
1. Jalankan perintah build berikut di terminal:
   ```bash
   flutter build apk --release --no-tree-shake-icons
   ```
2. File APK dapat ditemukan di direktori:
   build/app/outputs/flutter-apk/app-release.apk

---

## 💡 Arsitektur & Penjelasan Teknis
1. State Updates (Provider): Aplikasi menggunakan ActivityProvider untuk mengelola data dashboard secara terpusat. Fungsi resetData() diterapkan saat logout untuk memastikan data antar akun tidak bercampur (menghindari residu cache data user sebelumnya).

2. Local Storage (SharedPreferences): Digunakan untuk menyimpan auth_token agar fitur Auto-Login berjalan, serta menyimpan user_name untuk identitas pengguna pada header aplikasi tanpa menunggu request API.

3. Networking (Dio): Menangani komunikasi data JSON. Dilengkapi dengan header 'ngrok-skip-browser-warning': 'true' untuk memastikan request API tidak terhalang oleh halaman peringatan (interstitial) Ngrok.

---

## 👥 Contact Person (Tim Pengembang)
Jika terdapat kendala dalam pengujian aplikasi, silakan hubungi:
   Nama: M. Haris Tri Nugraha
   NIM: 2405109
   Jabatan: Ketua Tim / Lead Developer
   Email: haris3n@gmail.com   
   WhatsApp: 087755151505
   Git Repository: @haris3n

© 2025 HealthTrack Project - Tugas Besar Pemrograman Mobile.
