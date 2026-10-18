# Laporan Integrasi Backend & Interaktivitas Aplikasi Layarboxd

Dokumen ini menjelaskan arsitektur integrasi penuh antara antarmuka mobile **Layarboxd (Flutter)** dengan backend **Node.js Express**, **Prisma ORM**, database lokal **MySQL (XAMPP)**, dan integrasi katalog pihak ketiga **TMDB API**.

---

## 1. Arsitektur & Lingkungan Sistem

```
+-----------------------------------------------------------+
|               FLUTTER CLIENT (Web & Android APK)          |
|  - Films, Reviews, Lists, Journal                         |
|  - Search & Quick Log Sheet (+)                           |
|  - Movie Detail & Rating / Watchlist                      |
|  - User Profile & Settings Edit                           |
+-----------------------------+-----------------------------+
                              | REST API (JSON / Bearer JWT)
                              v
+-----------------------------------------------------------+
|                    EXPRESS.JS BACKEND                     |
|  - Port 3000                                              |
|  - JWT Authentication & Bcrypt Password Hashing           |
|  - Routes: /api/auth, /api/users, /api/movies,            |
|            /api/reviews, /api/watchlist                   |
+--------------------+---------------------+----------------+
                     |                     |
     Prisma ORM Query|                     | Axios HTTP
                     v                     v
+----------------------------+   +--------------------------+
|    MYSQL DATABASE (XAMPP)  |   |        TMDB API v3       |
|  - Database: layarboxd_db  |   |  - Real-time films &     |
|  - Port: 3306              |   |    posters metadata      |
|  - Relasi User, Movie,     |   +--------------------------+
|    Review, Watchlist       |
+----------------------------+
```

---

## 2. Rincian Endpoint Backend

### A. Autentikasi (`/api/auth`)
- **`POST /api/auth/register`**
  - Menerima: `{ email, username, password, name }`
  - Password dienkripsi dengan `bcrypt` salt 10 rounds.
- **`POST /api/auth/login`**
  - Menerima: `{ email, password }` (mendukung login menggunakan alamat email maupun username).
  - Mengembalikan: JWT Token valid 7 hari, data identitas pengguna (`id`, `username`, `name`, `email`).

### B. Film & TMDB (`/api/movies`)
- **`GET /api/movies/popular`**
  - Menarik daftar 20 film paling populer saat ini via TMDB API v3.
- **`GET /api/movies/search?q=:query`**
  - Mencari katalog film secara langsung dengan kata kunci judul.
- **`GET /api/movies/:id`**
  - Mengambil detail sinopsis, poster resolusi tinggi, sutradara, durasi, dan daftar pemeran (credits).

### C. Review & Komunitas (`/api/reviews`)
- **`GET /api/reviews`**
  - Mengambil ulasan komunitas terbaru dari database MySQL (ditampilkan pada tab *Reviews* di HomeScreen).
- **`POST /api/reviews`** *(Memerlukan Bearer Token)*
  - Menyimpan rating bintang (1–5), ulasan teks, dan otomatis mendaftarkan film ke database lokal jika belum ada.
- **`GET /api/reviews/movie/:tmdbId`**
  - Mengambil daftar ulasan untuk film spesifik.
- **`GET /api/reviews/my`** *(Memerlukan Bearer Token)*
  - Menampilkan riwayat film yang telah di-review user (tampil pada tab *Diary* profil).

### D. Watchlist (`/api/watchlist`)
- **`GET /api/watchlist`** *(Memerlukan Bearer Token)*
  - Mengambil daftar film yang dimasukkan ke antrean tonton pengguna.
- **`POST /api/watchlist`** *(Memerlukan Bearer Token)*
  - Menambahkan film ke antrean tonton.
- **`DELETE /api/watchlist/:tmdbId`** *(Memerlukan Bearer Token)*
  - Menghapus film dari antrean tonton pengguna.
- **`GET /api/watchlist/check/:tmdbId`** *(Memerlukan Bearer Token)*
  - Mengecek status apakah film ini sudah ada di watchlist user untuk memperbarui status ikon tombol.

### E. Profil Pengguna (`/api/users`)
- **`GET /api/users/profile`** *(Memerlukan Bearer Token)*
  - Menarik data profil lengkap, jumlah hitungan film, statistik, diary, dan watchlist.
- **`PUT /api/users/profile`** *(Memerlukan Bearer Token)*
  - Memperbarui data pengguna (`name`, `username`) langsung dari form pengaturan profil.

---

## 3. Fitur Interaktivitas yang Telah Berfungsi Penuh

1. **Sinkronisasi Otomatis:**
   - Ketika pengguna mengubah nama di **Profile Settings**, data diupdate ke database MySQL dan langsung tercermin di header **Profile Screen**.
2. **Watchlist Toggle Dua Arah:**
   - Ikon jam hijau/biru pada halaman detail film dapat ditekan untuk menambah atau membatalkan film dari antrean tonton.
3. **Log & Review Cepat (+):**
   - Menekan tombol hijau bulat di tengah navigasi bawah membuka Quick Log Sheet yang mencari film ke server TMDB dan membuka modal penulisan ulasan.
4. **Resistensi Offline / Fallback Cerdas:**
   - Jika koneksi internet terputus atau server backend sedang dimulai, aplikasi tidak crash melainkan menampilkan katalog fallback lokal yang terkurasi.
