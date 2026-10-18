# Panduan Menjalankan Aplikasi Layarboxd (Setup & Running Guide)

Panduan ini ditujukan bagi dosen, penguji, atau pengembang untuk menjalankan aplikasi **Layarboxd** secara lokal dari awal hingga siap diuji.

---

## Prasyarat Lingkungan (Prerequisites)

1. **Flutter SDK** (versi 3.x atau lebih baru)
2. **Node.js** (versi 18.x atau lebih baru, direkomendasikan LTS)
3. **XAMPP / MySQL Server** (berjalan pada port `3306`)
4. **Android SDK / Emulator / Chrome Browser**

---

## Langkah 1: Menjalankan Database MySQL (XAMPP)

1. Buka aplikasi **XAMPP Control Panel** di Windows.
2. Klik tombol **Start** pada modul **MySQL**.
3. Pastikan database `layarboxd_db` sudah ada:
   - Jika belum, buat database baru bernama `layarboxd_db` di phpMyAdmin (`http://localhost/phpmyadmin`) atau melalui terminal:
     ```bash
     mysql -u root -e "CREATE DATABASE IF NOT EXISTS layarboxd_db;"
     ```
   - Import skema dan data seed dari file:
     ```bash
     mysql -u root layarboxd_db < "d:\New folder\UTS_MOBILEDEV-main\UTS_MOBILEDEV-main\database\layarboxd_db.sql"
     ```

---

## Langkah 2: Menjalankan Server Backend (Node.js Express)

1. Buka terminal baru dan masuk ke direktori backend:
   ```bash
   cd "d:\New folder\UTS_MOBILEDEV-main\UTS_MOBILEDEV-main\backend"
   ```
2. Pastikan file `.env` sudah terpasang dengan konfigurasi berikut:
   ```env
   PORT=3000
   DATABASE_URL="mysql://root:@localhost:3306/layarboxd_db"
   JWT_SECRET="layarboxd_secret_key_uts_2026_super_secure"
   TMDB_API_KEY="2dca580c2a14b55200e784d157207b4d"
   ```
3. Install dependensi dan generate Prisma Client:
   ```bash
   npm install
   npx prisma generate
   ```
4. Jalankan server:
   ```bash
   node server.js
   ```
   *Output yang diharapkan:*
   ```
   Server Backend berjalan di http://localhost:3000
   ```

---

## Langkah 3: Menjalankan Aplikasi Flutter

### Opsi A: Menjalankan di Browser (Web)
Buka terminal baru di direktori root project Flutter:
```bash
cd "d:\New folder\UTS_MOBILEDEV-main"
flutter run -d chrome
# atau jalankan web server:
flutter run -d web-server --web-port=8080
```
Buka browser di `http://localhost:8080`.

### Opsi B: Menjalankan di Android Emulator / HP Fisik
Hubungkan perangkat Android Anda dengan USB debugging aktif atau nyalakan emulator Android:
```bash
cd "d:\New folder\UTS_MOBILEDEV-main"
flutter run
```

---

## Langkah 4: Memasang File APK yang Sudah Dibangun

Jika penguji ingin langsung menguji aplikasi pada perangkat Android tanpa perlu mengompilasi dari awal:

1. Ambil file APK yang sudah berhasil di-build pada path:
   `d:\New folder\UTS_MOBILEDEV-main\build\app\outputs\flutter-apk\app-debug.apk`
2. Pasang langsung ke emulator/HP menggunakan perintah:
   ```bash
   adb install -r "d:\New folder\UTS_MOBILEDEV-main\build\app\outputs\flutter-apk\app-debug.apk"
   ```

---

## Kredensial Akun Pengujian

Aplikasi telah dilengkapi dengan akun bawaan di database untuk pengujian cepat:
- **Email:** `aldi@email.com`
- **Username:** `aldi123`
- **Password:** `password123`
- **Nama:** `Aldi Mahasiswa`

*(Pengguna juga dapat menekan tombol **Sign Up** untuk mendaftarkan akun baru secara langsung ke database)*.
