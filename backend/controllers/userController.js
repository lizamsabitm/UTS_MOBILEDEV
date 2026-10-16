const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Fungsi Mengambil Profil User Sendiri
// Fungsi Mengambil Profil User Sendiri
exports.getProfile = async (req, res) => {
  try {
    // req.user.userId didapat dari authMiddleware yang baru saja kita buat
    const user = await prisma.user.findUnique({
      where: { id: req.user.userId },
      select: {
        id: true,
        email: true,
        username: true,
        name: true,
        // -- INI ADALAH KODE BARU YANG DITAMBAHKAN --
        // Menarik data review (diary) beserta detail filmnya
        reviews: {
          include: { movie: true },
          orderBy: { createdAt: 'desc' }
        },
        // Menarik data watchlist beserta detail filmnya
        watchlist: {
          include: { movie: true }
        }
        // ------------------------------------------
      }
    });

    if (!user) {
      return res.status(404).json({ error: "Pengguna tidak ditemukan" });
    }

    res.status(200).json({ data: user });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil profil", detail: error.message });
  }
};