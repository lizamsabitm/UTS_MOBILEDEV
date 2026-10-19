const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const parseId = (value) => {
  const n = parseInt(value, 10);
  return Number.isNaN(n) ? null : n;
};

// Tambahkan flag isFollowing (relatif terhadap viewer) ke daftar user
const attachIsFollowing = async (users, viewerId) => {
  if (users.length === 0) return [];
  const rows = await prisma.follows.findMany({
    where: { followerId: viewerId, followingId: { in: users.map((u) => u.id) } },
    select: { followingId: true },
  });
  const followed = new Set(rows.map((r) => r.followingId));
  return users.map((u) => ({ ...u, isFollowing: followed.has(u.id) }));
};

// POST /api/users/:id/follow
exports.followUser = async (req, res) => {
  try {
    const me = req.user.userId;
    const targetId = parseId(req.params.id);
    if (!targetId) return res.status(400).json({ error: "ID pengguna tidak valid" });
    if (targetId === me) return res.status(400).json({ error: "Tidak bisa mengikuti diri sendiri" });

    const target = await prisma.user.findUnique({ where: { id: targetId }, select: { id: true } });
    if (!target) return res.status(404).json({ error: "Pengguna tidak ditemukan" });

    await prisma.follows.upsert({
      where: { followerId_followingId: { followerId: me, followingId: targetId } },
      create: { followerId: me, followingId: targetId },
      update: {},
    });

    const followerCount = await prisma.follows.count({ where: { followingId: targetId } });
    res.status(200).json({ isFollowing: true, followerCount });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengikuti pengguna", detail: error.message });
  }
};

// DELETE /api/users/:id/follow
exports.unfollowUser = async (req, res) => {
  try {
    const me = req.user.userId;
    const targetId = parseId(req.params.id);
    if (!targetId) return res.status(400).json({ error: "ID pengguna tidak valid" });

    await prisma.follows.deleteMany({ where: { followerId: me, followingId: targetId } });

    const followerCount = await prisma.follows.count({ where: { followingId: targetId } });
    res.status(200).json({ isFollowing: false, followerCount });
  } catch (error) {
    res.status(500).json({ error: "Gagal berhenti mengikuti pengguna", detail: error.message });
  }
};

// GET /api/users/:id/followers
exports.getFollowers = async (req, res) => {
  try {
    const targetId = parseId(req.params.id);
    if (!targetId) return res.status(400).json({ error: "ID pengguna tidak valid" });

    const rows = await prisma.follows.findMany({
      where: { followingId: targetId },
      include: { follower: { select: { id: true, username: true, name: true } } },
    });
    const users = await attachIsFollowing(rows.map((r) => r.follower), req.user.userId);
    res.status(200).json({ data: users });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil daftar pengikut", detail: error.message });
  }
};

// GET /api/users/:id/following
exports.getFollowing = async (req, res) => {
  try {
    const targetId = parseId(req.params.id);
    if (!targetId) return res.status(400).json({ error: "ID pengguna tidak valid" });

    const rows = await prisma.follows.findMany({
      where: { followerId: targetId },
      include: { following: { select: { id: true, username: true, name: true } } },
    });
    const users = await attachIsFollowing(rows.map((r) => r.following), req.user.userId);
    res.status(200).json({ data: users });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil daftar yang diikuti", detail: error.message });
  }
};