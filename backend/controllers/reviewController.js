const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.addReview = async (req, res) => {
  try {
    const userId = req.user.userId; // Dari token JWT
    const { tmdbId, title, posterPath, rating, content } = req.body;

    // 1. Cek apakah film sudah di-cache di database lokal
    let movie = await prisma.movie.findUnique({
      where: { tmdbId: parseInt(tmdbId) }
    });

    // 2. Jika belum ada, simpan data film tersebut ke MySQL lokal
    if (!movie) {
      movie = await prisma.movie.create({
        data: {
          tmdbId: parseInt(tmdbId),
          title: title,
          posterPath: posterPath
        }
      });
    }

    // 3. Simpan review dengan mengaitkannya ke ID film lokal
    const newReview = await prisma.review.create({
      data: {
        userId: userId,
        movieId: movie.id,
        rating: parseFloat(rating),
        content: content
      }
    });

    res.status(201).json({ message: "Review berhasil disimpan", data: newReview });
  } catch (error) {
    res.status(500).json({ error: "Gagal menyimpan review", detail: error.message });
  }
};
exports.getReviewsByMovie = async (req, res) => {
  try {
    const { tmdbId } = req.params;
    const movie = await prisma.movie.findUnique({ where: { tmdbId: parseInt(tmdbId) } });
    
    if (!movie) return res.status(200).json({ data: [] }); // Belum ada review di database lokal

    const reviews = await prisma.review.findMany({
      where: { movieId: movie.id },
      include: { user: { select: { username: true, name: true } } }, // Tampilkan nama pereview
      orderBy: { createdAt: 'desc' }
    });
    res.status(200).json({ data: reviews });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil review film" });
  }
};

// Ambil semua review terkini dari semua pengguna (Feed Beranda)
exports.getAllReviews = async (req, res) => {
  try {
    const reviews = await prisma.review.findMany({
      take: 20,
      orderBy: { createdAt: 'desc' },
      include: {
        movie: true,
        user: { select: { id: true, username: true, name: true } }
      }
    });
    res.status(200).json({ data: reviews });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil daftar review", detail: error.message });
  }
};

// Ambil review pengguna yang sedang login (Diary)
exports.getMyReviews = async (req, res) => {
  try {
    const reviews = await prisma.review.findMany({
      where: { userId: req.user.userId },
      orderBy: { createdAt: 'desc' },
      include: { movie: true }
    });
    res.status(200).json({ data: reviews });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil review profil", detail: error.message });
  }
};