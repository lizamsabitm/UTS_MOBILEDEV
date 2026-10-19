const { PrismaClient } = require("@prisma/client");
const { reviewInclude, serializeReview } = require("../utils/reviewSerializer");
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
          orderBy: { createdAt: "desc" },
        },
        // Menarik data watchlist beserta detail filmnya
        watchlist: {
          include: { movie: true },
        },
        // Jumlah pengikut, yang diikuti, dan like yang diberikan
        _count: { select: { followers: true, following: true, likes: true } },
        // ------------------------------------------
      },
    });

    if (!user) {
      return res.status(404).json({ error: "Pengguna tidak ditemukan" });
    }

    res.status(200).json({ data: user });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Gagal mengambil profil", detail: error.message });
  }
};

// Fungsi Memperbarui Profil User
exports.updateProfile = async (req, res) => {
  try {
    const { name, username } = req.body;
    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (username !== undefined) updateData.username = username;

    const updatedUser = await prisma.user.update({
      where: { id: req.user.userId },
      data: updateData,
      select: {
        id: true,
        email: true,
        username: true,
        name: true,
      },
    });

    res
      .status(200)
      .json({ message: "Profil berhasil diperbarui", data: updatedUser });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Gagal memperbarui profil", detail: error.message });
  }
};

// GET /api/users/search?q=...  -> cari member lain (untuk di-follow)
exports.searchUsers = async (req, res) => {
  try {
    const q = (req.query.q || "").toString().trim();
    if (!q)
      return res
        .status(400)
        .json({ error: "Parameter pencarian (q) wajib diisi" });

    const me = req.user.userId;
    const users = await prisma.user.findMany({
      where: {
        id: { not: me },
        OR: [{ username: { contains: q } }, { name: { contains: q } }],
      },
      take: 20,
      select: {
        id: true,
        username: true,
        name: true,
        followers: { where: { followerId: me }, select: { followerId: true } },
      },
    });

    res.status(200).json({
      data: users.map(({ followers, ...u }) => ({
        ...u,
        isFollowing: followers.length > 0,
      })),
    });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Gagal mencari pengguna", detail: error.message });
  }
};
// GET /api/users/:id  -> profil publik user lain (tanpa email)
exports.getPublicProfile = async (req, res) => {
  try {
    const targetId = parseInt(req.params.id, 10);
    if (Number.isNaN(targetId))
      return res.status(400).json({ error: "ID pengguna tidak valid" });

    const me = req.user.userId;
    const user = await prisma.user.findUnique({
      where: { id: targetId },
      select: {
        id: true,
        username: true,
        name: true,
        _count: { select: { followers: true, following: true, reviews: true } },
        followers: { where: { followerId: me }, select: { followerId: true } },
      },
    });
    if (!user)
      return res.status(404).json({ error: "Pengguna tidak ditemukan" });

    const reviews = await prisma.review.findMany({
      where: { userId: targetId },
      orderBy: { createdAt: "desc" },
      take: 30,
      include: reviewInclude(me),
    });

    res.status(200).json({
      data: {
        id: user.id,
        username: user.username,
        name: user.name,
        followerCount: user._count.followers,
        followingCount: user._count.following,
        reviewCount: user._count.reviews,
        isFollowing: user.followers.length > 0,
        reviews: reviews.map(serializeReview),
      },
    });
  } catch (error) {
    res
      .status(500)
      .json({
        error: "Gagal mengambil profil pengguna",
        detail: error.message,
      });
  }
};
