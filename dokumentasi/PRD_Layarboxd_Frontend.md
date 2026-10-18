# PRD — Layarboxd (Letterboxd-inspired Flutter App)

> **Instruksi untuk Antigravity:** Baca dokumen ini sampai selesai, lalu kerjakan langsung di workspace/repository yang sedang terbuka. Jangan hanya memberi saran atau contoh kode. Audit proyek yang sudah ada terlebih dahulu, kemudian implementasikan frontend Flutter yang bisa dijalankan dan diintegrasikan dengan backend saat ini.

## 1. Ringkasan Proyek

**Nama kerja aplikasi:** Layarboxd. Jika `README.md`, konfigurasi aplikasi, atau kesepakatan tim pada repository sudah menentukan nama plesetan lain, ikuti nama yang sudah disepakati dan jangan menggantinya sepihak.

**Aplikasi referensi:** Letterboxd — aplikasi katalog dan jurnal film untuk mencari film, melihat detail, memberi rating, menulis ulasan, menandai film yang sudah ditonton, dan menyimpan film ke watchlist.

**Tujuan:** Membangun frontend Flutter untuk proyek UTS Pemrograman Aplikasi Bergerak dengan UI/UX yang sedekat mungkin dengan screenshot aplikasi Letterboxd yang akan dilampirkan pengguna di Antigravity. Frontend harus menggunakan REST API dan database yang sudah disiapkan oleh anggota tim.

**Batas tugas yang harus dipatuhi:** Fokus pada `frontend/`. Repository disebut memiliki folder `backend/`, `database/`, dan `frontend/`. Jangan membuat ulang backend atau database, jangan menghapus/mengganti pekerjaan anggota lain, dan jangan mengubah API yang sudah ada kecuali benar-benar diperlukan. Bila menemukan ketidaksesuaian, jelaskan dan pilih solusi frontend terlebih dahulu.

**Deadline akademik:** 20 Oktober 2026, pukul 23.59 WIB. Prioritaskan alur wajib dan stabilitas dibanding fitur tambahan.

## 2. Instruksi Awal untuk Antigravity: Audit Sebelum Coding

Sebelum mengedit file, lakukan langkah berikut:

1. Periksa struktur root repository dan baca `README.md`.
2. Buka `frontend/`, periksa `pubspec.yaml`, `lib/`, file konfigurasi, package yang sudah digunakan, dan kode yang sudah ada. Pertahankan struktur atau pola yang masih layak; jangan menimpa proyek yang telah berjalan.
3. Periksa `backend/` untuk mengetahui endpoint, nama field JSON, bentuk response, middleware autentikasi, dan konfigurasi port yang benar-benar dipakai.
4. Periksa script SQL/migration di `database/` hanya untuk memahami skema dan relasi yang tersedia. Jangan mengubah schema atau SQL untuk kebutuhan UI tanpa persetujuan.
5. Cocokkan endpoint yang ditemukan dengan bagian **Kontrak API** dalam dokumen ini. Kontrak di bawah merupakan informasi dari tim dan tetap harus diverifikasi terhadap kode aktual.
6. Setelah audit singkat, langsung lanjutkan implementasi frontend. Jangan berhenti hanya untuk mengembalikan laporan audit.
7. Jangan mengganti arsitektur/state management atau menambahkan banyak dependency bila repository sudah memiliki solusi yang bekerja. Gunakan dependensi yang ada terlebih dahulu.

Jika `frontend/` belum berisi proyek Flutter yang berfungsi, buat/rapikan proyek Flutter di folder itu saja. Jangan menaruh aplikasi Flutter di root repository dan jangan mengubah folder `backend/` serta `database/`.

## 3. Target Pengguna dan Kebutuhan

Pengguna adalah penonton film yang ingin:

- Membuat akun dan masuk ke aplikasi.
- Menelusuri film populer serta mencari judul tertentu.
- Melihat poster, backdrop, sinopsis, tahun, durasi, pemeran/cast, dan informasi film lain jika API menyediakannya.
- Menandai film sebagai sudah ditonton.
- Memberi rating bintang dan menulis ulasan.
- Menambahkan film ke watchlist dan melihat watchlist sendiri.
- Melihat profil, riwayat/diary tontonan, dan ulasan miliknya.
- Melihat ulasan dari pengguna lain pada halaman detail film.

## 4. Prioritas Lingkup

### P0 — Wajib selesai

1. Splash/session check dan navigasi awal.
2. Register, login, validasi form, penyimpanan token JWT, serta logout.
3. Home/Films menampilkan film populer dari backend.
4. Search film melalui backend.
5. Movie Detail beserta data yang tersedia dari backend.
6. Menandai film sudah ditonton.
7. Memberi rating dan mengirim review.
8. Menambah dan melihat watchlist.
9. Profil dan riwayat/diary berdasarkan respons profil.
10. Menampilkan review pengguna lain di detail film.
11. Loading, error, empty state, refresh, serta penanganan sesi/token.
12. Tampilan responsif, navigasi antarlayar, dan integrasi API nyata.

### P1 — Hanya jika P0 stabil dan backend mendukung

- Filter/pengelompokan film yang bisa dibuat dari metadata API yang sudah tersedia.
- Tab sederhana di profil untuk Film/Reviews/Journal jika datanya memang ada.
- Animasi kecil, shimmer/skeleton loading, dan penyempurnaan transisi.

### Di luar scope UTS versi ini

Jangan menghabiskan waktu untuk membuat fitur yang belum tersedia pada kontrak backend, seperti follow pengguna, activity feed sosial, like/komentar review, custom lists, statistik lanjutan, streaming availability provider, year-in-review, atau fitur premium. Screenshot yang memperlihatkan fitur tersebut dipakai sebagai referensi visual, bukan kewajiban implementasi. Jangan membuat tombol yang tampak berfungsi tetapi tidak melakukan aksi nyata.

## 5. Prinsip Desain Visual

Gunakan screenshot Letterboxd yang diunggah pengguna sebagai **sumber utama referensi visual**. Jangan menebak desain baru ketika screenshot sudah menunjukkan polanya. Pertahankan tampilan original-inspired namun gunakan nama plesetan aplikasi yang disepakati.

### 5.1 Palet warna

Gunakan warna awal berikut sebagai design token; sesuaikan tipis jika hasil inspeksi screenshot atau proyek menunjukkan nilai yang lebih tepat.

- `background`: `#14181C` — latar halaman utama charcoal gelap.
- `surface`: `#202830` atau `#27323A` — kartu dan panel.
- `headerBackground`: `#000000` — header/area branding pada layar yang menggunakannya.
- `textPrimary`: `#F5F7FA` — judul dan teks penting.
- `textSecondary`: `#9EADB9` — deskripsi, metadata, label sekunder.
- `divider`: `#303B45` — garis pemisah halus.
- `accentGreen`: `#00E054` — aksi utama bertema film seperti watched/rating terpilih/indikator tab aktif.
- `accentBlue`: `#40BCE8` — ikon/indikator navigasi aktif jika mengikuti screenshot.
- `navSlate`: `#405566` — latar bottom navigation.
- `accentOrange`: `#FF8000` — ikon liked/hearts jika ditampilkan sebagai dekorasi atau data yang didukung.

Semua warna harus didefinisikan terpusat dalam theme/constants, bukan di-hardcode berulang kali pada widget.

### 5.2 Gaya komponen

- Mobile-first, mengikuti proporsi layar Android pada screenshot.
- Latar dominan charcoal, header hitam, kontras teks jelas, aksen hijau untuk state aktif.
- Gunakan poster film portrait dengan rasio mendekati 2:3. Jangan merusak rasio gambar.
- Untuk detail film, gunakan backdrop lebar di bagian atas, overlay gelap/gradient agar teks terbaca, lalu judul dan poster vertikal jika data poster tersedia.
- Gunakan padding konsisten sekitar 16 px; jarak antarkartu sekitar 12–16 px.
- Radius kartu umumnya 8–12 px; hindari terlalu banyak shadow terang.
- Metadata (tahun, durasi, sutradara) lebih kecil dan berwarna sekunder.
- Judul penting tebal. Deskripsi maksimal beberapa baris di kartu, dengan opsi membuka detail jika panjang.
- Film grid: 3–4 poster per baris sesuai lebar layar; prioritaskan poster, minimalkan teks di grid.
- Hindari tampilan generik Material yang tidak mirip referensi. Kustomisasi AppBar, tab indicator, bottom navigation, kartu, dan tombol.
- Hormati safe area/status bar Android. Bottom navigation tidak boleh menutupi konten.
- Gunakan aset lokal/ikon vektor sederhana jika perlu. Jangan memasukkan poster palsu permanen atau gambar hasil hotlink tidak stabil.

### 5.3 Navigasi utama

Gunakan bottom navigation bar gelap slate dengan tiga destinasi yang konsisten dengan screenshot:

1. **Profile/Account** — ikon pengguna; menuju profil dan riwayat.
2. **Films/Home** — ikon tumpukan/poster; menuju daftar film populer.
3. **Search** — ikon pencarian; menuju pencarian/browse.

State ikon aktif harus jelas. Pertahankan state layar dan hindari membuat instance halaman berulang ketika berpindah tab jika implementasi yang ada memungkinkan.

Di halaman profil, tampilkan tab horizontal seperti **Films**, **Reviews**, **Watchlist** atau **Journal** hanya jika alur datanya dapat didukung oleh respons API. Tab dapat memakai indikator garis hijau seperti screenshot. Jangan membuat tab sosial palsu.

## 6. Struktur Halaman dan Perilaku

### 6.1 Splash dan Session Check

- Tampilkan identitas aplikasi (nama plesetan yang disepakati) di latar gelap.
- Cek apakah token pernah disimpan.
- Jika token tersedia, coba masuk ke Home atau validasi sesi secara aman sesuai kemampuan API.
- Jika token tidak tersedia, tampilkan layar masuk atau landing singkat.
- Jangan menampilkan layar splash terlalu lama; tidak perlu animasi kompleks.

### 6.2 Login

Elemen:
- Branding aplikasi.
- Input email.
- Input password dengan toggle show/hide.
- Tombol utama Sign in/Login.
- Arah menuju Create account/Register.
- Indikator loading ketika request berjalan.

Perilaku:
- Validasi email kosong/format tidak benar dan password kosong.
- Kirim request ke endpoint login.
- Jika sukses, ambil token dari response aktual, simpan dengan mekanisme penyimpanan lokal yang sesuai, lalu navigasi ke Home.
- Jika gagal, tampilkan pesan yang mudah dipahami; jangan menampilkan stack trace atau data sensitif.
- Cegah double-submit ketika request sedang berjalan.

### 6.3 Register

Elemen:
- Background/header visual bertema film yang gelap jika aset yang tersedia memungkinkan. Jangan mengunduh gambar tidak jelas atau menghambat stabilitas hanya demi artwork onboarding.
- Input nama, email, username, password.
- Validasi wajib/format dan toggle password.
- Tombol Create account/Register dan tautan kembali ke Sign in.

Perilaku:
- Kirim field `email`, `username`, `password`, `name` sesuai kontrak backend.
- Validasi input di sisi UI, tetapi tetap tampilkan pesan validasi dari backend.
- Jika berhasil, arahkan login atau langsung masuk hanya jika backend benar-benar mengembalikan token.
- Jangan menyimpan password secara lokal.

### 6.4 Home / Films

Tujuan: menjadi katalog film utama dan terasa seperti tampilan film grid Letterboxd.

Elemen:
- Header logo/nama Layarboxd di latar hitam atau gaya header dari screenshot.
- Bagian **Popular this week** atau judul setara yang konsisten dengan respons endpoint.
- Poster film populer dalam grid responsif.
- Informasi tambahan seperti judul/tahun dapat ditaruh di bawah poster bila ruang cukup.
- Pull-to-refresh atau tombol retry untuk memuat ulang.
- Klik poster/kartu membuka Movie Detail.

Perilaku:
- Data harus berasal dari `GET /movies/popular`.
- Jangan hardcode data film untuk menggantikan API. Data dummy hanya boleh dipakai sementara selama pengembangan dan harus dihapus/diisolasi sebelum final.
- Gunakan loading skeleton/placeholder saat request berjalan.
- Bila kosong, tampilkan empty state dan opsi muat ulang.
- Bila error jaringan, tampilkan error ramah dan tombol Retry.
- Jika endpoint memberi pagination, ikuti mekanismenya; jika tidak, jangan mengarang parameter pagination.

### 6.5 Search / Browse

Elemen:
- Search bar besar dengan latar slate kebiruan, ikon search, dan placeholder `Search` seperti screenshot.
- Hasil berupa poster grid/list yang mudah dipindai.
- State pencarian awal bisa menampilkan label kategori sederhana hanya bila datanya tersedia; jangan menampilkan kategori seolah interaktif bila belum bekerja.
- Tombol clear query.

Perilaku:
- Gunakan `GET /movies/search?q={query}`.
- Encode query secara benar ketika membuat URL.
- Hindari mengirim request pada setiap karakter tanpa kendali. Gunakan debounce ringan jika arsitektur mendukung, atau lakukan pencarian saat submit/ketika pengguna memilih ikon search.
- Tampilkan loading, tidak ada hasil, error, dan hasil pencarian dengan jelas.
- Ketuk film membuka Movie Detail.

### 6.6 Movie Detail

Ini salah satu layar terpenting dan harus mengikuti screenshot sedekat mungkin.

Susunan yang diutamakan:
1. Backdrop film yang lebar di atas, ditutup gradient gelap untuk transisi ke panel detail.
2. Tombol kembali dan menu tambahan yang hanya muncul bila aksinya nyata.
3. Judul film, tahun rilis, sutradara, durasi, dan poster kecil di samping bila tersedia pada response.
4. Tombol trailer hanya bila URL trailer benar-benar tersedia dan dapat dibuka; jika tidak ada, hilangkan tombol tersebut.
5. Tagline dan sinopsis.
6. Ringkasan rating jika ada. Jangan membuat rating rata-rata palsu apabila API tidak menyediakannya.
7. Aksi utama: **Watched/Log**, **Rate & Review**, dan **Add to Watchlist**.
8. Cast list dengan foto dan nama jika response menyediakan data `credits`; bila hanya nama tersedia, tetap tampilkan nama tanpa foto.
9. Bagian **Popular reviews/Reviews** yang dimuat dari endpoint review film.
10. Bagian film terkait hanya bila backend menyediakan data film terkait; jika tidak, jangan tampilkan data palsu.

Perilaku:
- Gunakan `GET /movies/:id`, dengan `id` adalah `tmdbId`.
- Baca bentuk JSON aktual sebelum membuat model. Respons diketahui dapat memuat `credits`, tetapi bentuk field perlu diverifikasi.
- Poster dan backdrop mengikuti nilai image path yang diberikan API. Bila backend mengembalikan path relatif TMDB, gunakan base image URL yang sesuai; bila URL sudah lengkap, jangan menambahkan base URL dua kali.
- Jika image gagal dimuat, tampilkan placeholder gelap yang rapi.
- Tombol Watchlist harus menunjukkan state berhasil hanya setelah API sukses atau data profil/watchlist memang mengonfirmasi item tersebut.
- Saat berpindah kembali ke layar sebelumnya, perbarui state watchlist/riwayat bila dibutuhkan.

### 6.7 Watched, Rating, dan Review

Gunakan bottom sheet atau modal gelap yang terasa native dengan desain screenshot.

Konten:
- Judul/poster film.
- Aksi **Watched**.
- Pemilihan rating bintang hingga 5, termasuk setengah bintang jika implementasi yang ada mendukung dengan baik. Bila setengah bintang berisiko menghambat, gunakan 1–5 bintang penuh.
- Input review multiline.
- Tombol Save/Log.

Perilaku:
- Menandai film sudah ditonton tanpa rating/review menggunakan `POST /reviews` dengan `rating: 0` dan `content: ""`, sesuai penjelasan backend bahwa pola ini dicatat sebagai watched/diary.
- Mengirim rating/review menggunakan `POST /reviews` dengan `tmdbId`, `title`, `posterPath`, `rating`, dan `content`.
- Jangan kirim dua request hanya karena pengguna menekan Watch dan kemudian Save pada satu interaksi. Tentukan satu alur submit yang jelas.
- Cegah submit ganda saat loading.
- Setelah sukses, tutup sheet, beri umpan balik singkat, lalu refresh state profil/diary dan review film yang relevan.
- Jika film telah direkam sebelumnya, periksa dukungan update di backend terlebih dahulu. Jangan membuat endpoint update sendiri dan jangan mengirim duplikat otomatis.
- Bila backend menerima rating dalam format tertentu (integer/desimal), ikuti implementasi aktual dan sesuaikan pemetaan UI secara eksplisit.

### 6.8 Watchlist

Akses watchlist dari profil dan/atau aksi pada halaman detail.

Elemen:
- Judul **Watchlist**.
- Grid poster film; jika data tersedia, tampilkan judul dan tahun.
- State kosong yang mengajak pengguna mencari film dan menambahkannya.

Perilaku:
- Ambil data dari `GET /watchlist` (token JWT wajib).
- Tambah film melalui `POST /watchlist` dengan `tmdbId`, `title`, `posterPath`.
- Tombol Add to Watchlist di detail film menunjukkan state loading dan hasil respons API.
- Tidak ada endpoint hapus yang diberikan dalam kontrak awal. Periksa kode backend. Implementasikan hapus hanya jika benar-benar tersedia. Jika tidak tersedia, jangan membuat seolah-olah penghapusan sudah tersimpan; cukup jangan menyediakan aksi hapus atau jelaskan keterbatasan pada catatan akhir.
- Hindari duplikasi item. Bila backend mengembalikan konflik/duplikasi, tampilkan pesan yang wajar dan refresh data.

### 6.9 Profile dan Journal/Watch History

Elemen:
- Avatar inisial atau placeholder jika API tidak menyediakan foto profil.
- Username/nama pengguna.
- Ringkasan jumlah film atau rating rata-rata hanya jika nilainya bisa dihitung dengan benar dari data yang ada.
- Tab/segmen untuk **Watched/Journal**, **Reviews**, dan **Watchlist** sesuai data yang tersedia.
- Riwayat ditata seperti diary: tanggal/bulan, poster kecil, judul film, tahun, rating, dan cuplikan review jika tersedia.

Perilaku:
- Gunakan `GET /users/profile` dengan token JWT.
- Menurut kontrak tim, response profil merangkum data user, array `reviews` untuk riwayat tontonan/diary, dan array `watchlist`. Verifikasi bentuk response aktual.
- Bila endpoint mengembalikan `reviews` yang mencampur entri watched dan review, klasifikasikan sesuai field yang nyata: misalnya rating 0 berarti entri watched tanpa rating; jangan mengarang field diary terpisah.
- Tampilkan tombol Logout yang menghapus token lokal dan mengarahkan ke Login.
- Setelah login/logout atau mutasi review/watchlist, refresh data profil bila relevan.
- Tangani profil tanpa riwayat atau watchlist dengan empty state yang menarik.

### 6.10 Reviews Film

- Pada Movie Detail, panggil `GET /reviews/movie/:tmdbId`.
- Tampilkan nama/username, rating, dan isi review hanya berdasarkan data response.
- Bila pengguna belum login, review yang bisa dibaca tetap dapat ditampilkan jika API mengizinkannya; tombol untuk mengirim review harus meminta login jika endpoint mewajibkan JWT.
- Bila belum ada review, tampilkan empty state dan CTA untuk menjadi reviewer pertama jika login.
- Tampilkan maksimal beberapa review awal agar detail tidak terlalu berat; bila implementasi endpoint tidak mendukung pagination, tampilkan daftar yang dikembalikan.

## 7. Kontrak REST API

**Base URL:** `http://localhost:3000/api` pada lingkungan backend lokal desktop. Jangan hardcode satu alamat yang tidak bisa diganti. Buat satu konfigurasi API base URL yang jelas dan bisa diganti lewat `--dart-define` atau konfigurasi development.

Alamat umum:
- Android Emulator: gunakan `http://10.0.2.2:3000/api` untuk menjangkau server localhost pada host laptop.
- HP Android fisik: gunakan IP LAN laptop, misalnya `http://192.168.x.x:3000/api`, serta pastikan perangkat dan laptop berada pada jaringan yang bisa saling menjangkau.
- Flutter Web/iOS/lingkungan lain: tentukan sesuai runtime dan konfigurasi backend; jangan menganggap `localhost` selalu menunjuk ke laptop.

### 7.1 Auth

**Register**
- `POST /auth/register`
- JSON body: `email`, `username`, `password`, `name`.

**Login**
- `POST /auth/login`
- JSON body: `email`, `password`.
- Ambil JWT dari property yang benar-benar dikembalikan response; jangan mengasumsikan nama properti token tanpa memeriksa backend.

**Logout**
- Berdasarkan informasi tim, logout cukup menghapus JWT dari penyimpanan lokal dan kembali ke layar Login. Jangan mengarang endpoint logout.

### 7.2 Movies — tidak membutuhkan JWT menurut informasi tim

- Popular: `GET /movies/popular`
- Search: `GET /movies/search?q=judul_film`
- Detail: `GET /movies/:id`

### 7.3 Reviews / Watchlist — memerlukan JWT

Header untuk endpoint terlindungi:

```http
Authorization: Bearer <JWT>
```

- Tambah watched/review/rating: `POST /reviews`
  - JSON body: `tmdbId`, `title`, `posterPath`, `rating`, `content`.
  - Untuk watched tanpa rating/review: `rating: 0`, `content: ""`.
- Review film oleh pengguna: `GET /reviews/movie/:tmdbId`.
- Tambah watchlist: `POST /watchlist`
  - JSON body: `tmdbId`, `title`, `posterPath`.
- Lihat watchlist: `GET /watchlist`.

### 7.4 Profile

- `GET /users/profile` dengan JWT.
- Menurut informasi tim, response merangkum objek user, array `reviews` untuk riwayat tontonan/diary, dan array `watchlist`.

### 7.5 Aturan integrasi API

- Semua request API diletakkan dalam service/repository, bukan ditulis tersebar di widget.
- Buat satu interceptor/helper untuk menyertakan `Authorization: Bearer ...` pada endpoint terproteksi.
- Jangan mengirim token pada endpoint publik jika tidak diperlukan.
- Periksa format sukses/error aktual dan parse dengan aman. Backend dapat memiliki struktur seperti `{ data: ... }` atau langsung mengembalikan objek; jangan menebak sebelum membaca kode/hasil respons.
- Gunakan model Dart bertipe untuk data penting (auth, movie, review, watchlist, profile) bila sesuai pola proyek.
- Toleransi field nullable: poster, backdrop, cast, tahun, durasi, sinopsis, username, serta review bisa kosong.
- Tangani HTTP 401/403 dengan menghapus sesi dan meminta login kembali secara wajar; jangan membuat loop navigasi.
- Tangani timeout, no internet, response JSON tak terduga, dan server error dengan pesan ramah serta Retry.
- Jangan pernah memasukkan API key TMDB atau secret backend ke dalam source frontend. Frontend hanya mengakses backend yang sudah mengelola key.
- Jangan menampilkan password/token ke log. Log debug harus aman dan dapat dimatikan untuk build final.

## 8. Implementasi Flutter dan Arsitektur

Ikuti arsitektur yang sudah ada. Jika frontend masih kosong, gunakan pembagian sederhana dan mudah dipahami; jangan membuat arsitektur terlalu kompleks menjelang deadline.

Contoh struktur bila belum tersedia:

```text
frontend/
  lib/
    main.dart
    app.dart
    core/
      config/api_config.dart
      theme/app_theme.dart
      network/api_client.dart
      storage/token_storage.dart
      widgets/
        app_bottom_nav.dart
        movie_poster_card.dart
        loading_state.dart
        error_state.dart
        empty_state.dart
    features/
      auth/
        data/auth_service.dart
        presentation/login_screen.dart
        presentation/register_screen.dart
      movies/
        data/movie_service.dart
        data/movie_model.dart
        presentation/home_screen.dart
        presentation/search_screen.dart
        presentation/movie_detail_screen.dart
      reviews/
        data/review_service.dart
        presentation/review_editor_sheet.dart
      watchlist/
        data/watchlist_service.dart
        presentation/watchlist_screen.dart
      profile/
        data/profile_service.dart
        presentation/profile_screen.dart
        presentation/journal_screen.dart
```

Struktur tersebut hanya saran. Jika repository sudah memiliki struktur yang berbeda dan layak, pertahankan pola yang ada.

### Dependency

- Gunakan dependency yang sudah terpasang terlebih dahulu.
- Jika diperlukan, pilih library HTTP yang sudah digunakan repository (misalnya Dio atau `http`), jangan memasang keduanya tanpa alasan.
- Gunakan penyimpanan token aman jika dependency/pola proyek mendukung. Jika tidak, SharedPreferences boleh menjadi fallback untuk proyek UTS, tetapi jangan menyimpan password.
- Untuk gambar jaringan, gunakan package cache yang sudah ada; jika belum ada dan benar-benar diperlukan, tambah satu package yang stabil.
- Setelah mengubah `pubspec.yaml`, jalankan `flutter pub get`.
- Hindari dependency animasi, state management, atau UI berukuran besar hanya untuk efek kosmetik.

### Manajemen state

- Gunakan solusi yang sudah dipakai project.
- Jika belum ada, gunakan `setState`/service sederhana atau Provider hanya bila membantu konsistensi; jangan menambahkan Riverpod/BLoC besar bila tidak diperlukan.
- Pisahkan loading, error, dan data state.
- Setelah add watchlist atau submit review berhasil, sinkronkan state yang relevan tanpa memaksa pengguna restart aplikasi.

## 9. Model Data Minimum

Sesuaikan nama field dengan JSON backend setelah inspeksi. Hindari asumsi field yang tidak ada.

**Movie** (field potensial):
- `id` / `tmdbId`
- `title`
- `release_date` atau `releaseDate`
- `poster_path` atau `posterPath`
- `backdrop_path` atau `backdropPath`
- `overview`
- `runtime`
- `credits.cast`
- metadata lain yang benar-benar dikembalikan API

**Review/Diary entry** (sesuaikan backend):
- `tmdbId`
- `title`
- `posterPath`
- `rating`
- `content`
- `createdAt` / tanggal log jika ada
- informasi user jika response menyediakannya

**Profile**:
- `user` atau objek profil setara
- `reviews` array
- `watchlist` array

Model harus toleran terhadap field opsional atau nilai `null`, dan jangan crash saat sebagian metadata film tidak tersedia.

## 10. Kriteria Penerimaan (Acceptance Criteria)

Pekerjaan dinilai siap jika poin berikut berhasil diuji di perangkat/emulator yang sesuai:

### Auth
- [ ] Pengguna dapat register dengan nama, email, username, dan password.
- [ ] Form menolak input kosong/format tidak valid dengan pesan jelas.
- [ ] Pengguna dapat login dan token tersimpan.
- [ ] Setelah aplikasi dibuka lagi, sesi dipulihkan sesuai token yang tersedia.
- [ ] Logout menghapus token dan kembali ke Login.

### Films dan Search
- [ ] Home menampilkan data dari endpoint popular, bukan data hardcode.
- [ ] Poster ditampilkan dengan proporsi baik dan fallback bila gambar gagal.
- [ ] Search mengambil hasil dari API dan menampilkan empty/error/loading state.
- [ ] Memilih poster membuka detail film yang benar.

### Detail, review, dan watched
- [ ] Detail film memuat informasi yang tersedia dan tidak crash saat data nullable.
- [ ] Pemeran/cast tampil bila response menyediakan `credits`.
- [ ] Review pengguna lain dimuat dari endpoint review film.
- [ ] Pengguna yang login bisa menandai film watched.
- [ ] Pengguna bisa memilih rating, menulis review, dan menyimpan.
- [ ] State hanya berubah menjadi berhasil setelah backend mengonfirmasi sukses.

### Watchlist dan profil
- [ ] Pengguna bisa menambahkan film ke watchlist.
- [ ] Daftar watchlist ditampilkan dari backend.
- [ ] Profil dan riwayat/diary diambil dari endpoint profil.
- [ ] Empty state terlihat wajar untuk user baru.
- [ ] Request terproteksi menyertakan bearer token.

### UI/UX dan kualitas
- [ ] Tema gelap, warna, poster grid, detail/backdrop, tab indikator hijau, dan bottom navigation terasa konsisten dengan screenshot referensi.
- [ ] Tidak ada overflow pada layar Android yang diuji.
- [ ] Navigasi back bekerja.
- [ ] Tombol tidak dibiarkan tanpa aksi nyata.
- [ ] Error jaringan tidak menyebabkan aplikasi crash.
- [ ] `flutter analyze` dijalankan; masalah penting diperbaiki.
- [ ] `flutter run` berhasil pada emulator/perangkat yang tersedia.
- [ ] Backend dan folder database tidak mengalami perubahan tak terkait.

## 11. Urutan Pengerjaan yang Disarankan

Ikuti urutan berikut agar hasil cepat bisa diuji end-to-end:

1. **Audit repository dan kontrak API.** Pastikan frontend path, paket, schema response dan base URL.
2. **Buat design system dan navigasi.** Theme gelap, typography, bottom navigation, movie poster card, loading/error/empty widget.
3. **Selesaikan auth.** Register/login/token dan session gate.
4. **Selesaikan home dan search.** Gunakan API sesungguhnya sejak awal.
5. **Selesaikan movie detail.** Backdrop, poster, sinopsis, cast, dan review film.
6. **Selesaikan watched/rating/review.** Integrasikan `POST /reviews` dengan aturan payload backend.
7. **Selesaikan watchlist dan profile/journal.** Ambil data asli dari endpoint terproteksi.
8. **Uji seluruh alur.** Register/login → popular/search → detail → watched/review → watchlist → profile/diary → logout.
9. **Rapikan UI dan dokumentasi perubahan.** Jalankan analisis/build dan catat jika ada endpoint yang ternyata belum tersedia.

## 12. Batasan Teknis dan Hal yang Jangan Dilakukan

- Jangan mengubah API endpoint/response secara sepihak.
- Jangan menulis ulang folder `backend/` atau file SQL di `database/`.
- Jangan menghapus atau mengganti kode frontend yang telah dibuat anggota tim sebelum memahami fungsinya.
- Jangan hardcode daftar film/review sebagai hasil final.
- Jangan membuat data cast, rating, tanggal, sutradara, atau provider streaming palsu bila tidak dikembalikan API.
- Jangan menampilkan fitur seolah berfungsi jika backend tidak mendukungnya.
- Jangan commit API key, password database, `.env`, atau token.
- Jangan mengganti nama package/application ID tanpa alasan teknis yang jelas.
- Jangan berhenti setelah membuat mockup; implementasikan halaman nyata, integrasi API, dan state interaksi.
- Jangan mengorbankan fungsionalitas inti demi animasi atau fitur sosial tambahan.

## 13. Output yang Harus Dihasilkan Antigravity

Setelah mengerjakan, berikan ringkasan singkat yang mencantumkan:

1. Halaman/fitur yang telah dibuat dan benar-benar berfungsi.
2. File penting yang ditambahkan atau diubah di dalam `frontend/`.
3. Package baru yang dipasang (jika ada) dan alasannya.
4. Cara menjalankan frontend serta cara mengatur API base URL untuk emulator/HP fisik.
5. Hasil `flutter analyze` dan build/run yang benar-benar dijalankan; jangan mengklaim tes lulus jika belum dijalankan.
6. API/fitur yang tidak bisa diselesaikan karena kontrak backend tidak tersedia atau tidak cocok.
7. Langkah pengujian manual dari login sampai watchlist dan riwayat tontonan.

**Prioritas akhir:** UI yang menyerupai screenshot Letterboxd, alur fitur wajib yang benar-benar berjalan, integrasi dengan backend tim, dan kode Flutter yang stabil. Selesaikan P0 lebih dahulu sebelum mencoba P1.
