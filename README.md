# 🎬 Dokumentasi Lengkap Aplikasi Layarboxd (Letterboxd Clone)

**Proyek:** Ujian Tengah Semester (UTS) Pemrograman Aplikasi Bergerak 2026  
**Tech Stack:** Flutter (Frontend), Express.js + Prisma ORM (Backend), MySQL XAMPP (Database), TMDB API v3 (Movie Service).

---

## 📁 Struktur Berkas Dokumentasi

Semua berkas dokumentasi proyek telah dirangkum dalam satu folder ini:

```
d:\New folder\dokumentasi\
├── README.md                          <-- (Dokumen ini) Ringkasan & Indeks Utama
├── PRD_Layarboxd_Frontend.md          <-- Dokumen Spesifikasi Kebutuhan Produk (PRD)
├── LAPORAN_INTEGRASI_BACKEND.md       <-- Rincian Teknis Endpoint & Integrasi Database
├── PANDUAN_SETUP_DAN_RUNNING.md       <-- Panduan Instalasi & Menjalankan Proyek
└── screenshots/                       <-- Bukti Tangkapan Layar & Video Pengujian
    ├── 01_beranda_film_populer.png
    ├── 02_ulasan_komunitas_live_mysql.png
    ├── 03_quick_log_pencarian_film.png
    ├── 04_halaman_profil_user.png
    ├── 05_form_edit_profil_settings.png
    ├── 06_profil_setelah_diedit_database.png
    └── video_demo_interaksi.webp
```

---

## 🌟 Fitur Utama yang Telah Diimplementasikan

### 1. Sebelum Login (Authentication Experience)
- **Splash Screen:** Tampilan cinematic onboarding dengan tombol *Get Started* dan opsi masuk akun.
- **Login Screen:** Form login modern Letterboxd-style dengan validasi kredensial langsung ke backend.
- **Register Screen:** Pendaftaran pengguna baru lengkap dengan enkripsi password `bcrypt`.

### 2. Setelah Login (Main Application Experience)
- **Bottom Navigation 5 Menu:**
  - 🎬 **Films:** Katalog film populer TMDB, poster grid, carousel trending, dan editorial.
  - 🔍 **Search:** Pencarian film *real-time* dengan *debouncing* dan kategori eksplorasi.
  - ➕ **Center Green Quick Log:** Akses cepat modal pencarian dan pencatatan film dari layar mana saja.
  - ⚡ **Activity:** Feed aktivitas teman dan personal bertema *The Prestige*.
  - 👤 **Profile:** Statistik lengkap (Films, Diary, Reviews, Watchlist, Lists), histogram rating, dan foto profil.
- **Halaman Detail Film (`MovieDetailScreen`):**
  - Banner latar belakang dan poster film beresolusi tinggi.
  - Grafik distribusi rating anggota, ringkasan sinopsis, sutradara, durasi, dan daftar pemeran.
  - Tombol aksi: **Watched**, **Like**, **Watchlist**, dan dialog input ulasan & rating bintang 1–5.
- **Halaman Pengaturan Profil (`ProfileSettingsScreen`):**
  - Form interaktif untuk mengubah nama, email, lokasi, situs web, bio, dan kata ganti.
  - Perubahan data tersimpan secara langsung ke database MySQL dan langsung terupdate di tampilan profil.

---

## 🚀 Panduan Ringkas Menjalankan Proyek

1. **Jalankan MySQL:** Buka XAMPP dan nyalakan modul MySQL (`port 3306`).
2. **Jalankan Backend:**
   ```bash
   cd "d:\New folder\UTS_MOBILEDEV-main\UTS_MOBILEDEV-main\backend"
   node server.js
   ```
3. **Jalankan Flutter:**
   ```bash
   cd "d:\New folder\UTS_MOBILEDEV-main"
   flutter run -d chrome
   ```
4. **Build APK Android:**
   File APK siap pakai berlokasi di:
   `d:\New folder\UTS_MOBILEDEV-main\build\app\outputs\flutter-apk\app-debug.apk`

---

## 📸 Pratinjau Tampilan & Hasil Pengujian

| Beranda Film Populer | Ulasan Komunitas (Live MySQL) | Quick Log Sheet |
| :---: | :---: | :---: |
| ![Beranda](dokumentasi/screenshots/01_beranda_film_populer.png) | ![Ulasan](dokumentasi/screenshots/02_ulasan_komunitas_live_mysql.png) | ![Quick Log](dokumentasi/screenshots/03_quick_log_pencarian_film.png) |

| Halaman Profil Pengguna | Form Edit Profil | Profil Setelah Diperbarui |
| :---: | :---: | :---: |
| ![Profil](dokumentasi/screenshots/04_halaman_profil_user.png) | ![Edit Profil](dokumentasi/screenshots/05_form_edit_profil_settings.png) | ![Saved](dokumentasi/screenshots/06_profil_setelah_diedit_database.png) |

