const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.addToWatchlist = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { tmdbId, title, posterPath } = req.body;

    // Cek dan simpan film ke lokal seperti logika review
    let movie = await prisma.movie.findUnique({
      where: { tmdbId: parseInt(tmdbId) }
    });

    if (!movie) {
      movie = await prisma.movie.create({
        data: { tmdbId: parseInt(tmdbId), title, posterPath }
      });
    }

    // Tambahkan ke tabel Watchlist
    await prisma.watchlist.create({
      data: {
        userId: userId,
        movieId: movie.id
      }
    });

    res.status(201).json({ message: "Film berhasil ditambahkan ke Watchlist" });
  } catch (error) {
    // P2002 adalah kode error Prisma jika data ganda (sudah ada di watchlist)
    if (error.code === 'P2002') {
      return res.status(400).json({ error: "Film sudah ada di watchlist kamu" });
    }
    res.status(500).json({ error: "Gagal menambahkan ke watchlist", detail: error.message });
  }
};
exports.getWatchlist = async (req, res) => {
  try {
    const watchlist = await prisma.watchlist.findMany({
      where: { userId: req.user.userId },
      include: { movie: true } // Sertakan data filmnya
    });
    res.status(200).json({ data: watchlist });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil daftar watchlist" });
  }
};