const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Kolom ReviewComment.content di MySQL adalah VARCHAR(191)
const MAX_COMMENT_LENGTH = 191;

const parseId = (value) => {
  const n = parseInt(value, 10);
  return Number.isNaN(n) ? null : n;
};

// POST /api/reviews/:id/like
exports.likeReview = async (req, res) => {
  try {
    const userId = req.user.userId;
    const reviewId = parseId(req.params.id);
    if (!reviewId) return res.status(400).json({ error: "ID review tidak valid" });

    const review = await prisma.review.findUnique({ where: { id: reviewId }, select: { id: true } });
    if (!review) return res.status(404).json({ error: "Review tidak ditemukan" });

    await prisma.reviewLike.upsert({
      where: { userId_reviewId: { userId, reviewId } },
      create: { userId, reviewId },
      update: {},
    });

    const likeCount = await prisma.reviewLike.count({ where: { reviewId } });
    res.status(200).json({ liked: true, likeCount });
  } catch (error) {
    res.status(500).json({ error: "Gagal menyukai review", detail: error.message });
  }
};

// DELETE /api/reviews/:id/like
exports.unlikeReview = async (req, res) => {
  try {
    const userId = req.user.userId;
    const reviewId = parseId(req.params.id);
    if (!reviewId) return res.status(400).json({ error: "ID review tidak valid" });

    await prisma.reviewLike.deleteMany({ where: { userId, reviewId } });

    const likeCount = await prisma.reviewLike.count({ where: { reviewId } });
    res.status(200).json({ liked: false, likeCount });
  } catch (error) {
    res.status(500).json({ error: "Gagal membatalkan like", detail: error.message });
  }
};

// GET /api/reviews/:id/comments
exports.getComments = async (req, res) => {
  try {
    const reviewId = parseId(req.params.id);
    if (!reviewId) return res.status(400).json({ error: "ID review tidak valid" });

    const comments = await prisma.reviewComment.findMany({
      where: { reviewId },
      orderBy: { createdAt: 'asc' },
      include: { user: { select: { id: true, username: true, name: true } } },
    });
    res.status(200).json({ data: comments });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil komentar", detail: error.message });
  }
};

// POST /api/reviews/:id/comments   body: { content }
exports.addComment = async (req, res) => {
  try {
    const userId = req.user.userId;
    const reviewId = parseId(req.params.id);
    if (!reviewId) return res.status(400).json({ error: "ID review tidak valid" });

    const content = (req.body.content || '').toString().trim();
    if (!content) return res.status(400).json({ error: "Komentar tidak boleh kosong" });
    if (content.length > MAX_COMMENT_LENGTH) {
      return res.status(400).json({ error: `Komentar maksimal ${MAX_COMMENT_LENGTH} karakter` });
    }

    const review = await prisma.review.findUnique({ where: { id: reviewId }, select: { id: true } });
    if (!review) return res.status(404).json({ error: "Review tidak ditemukan" });

    const comment = await prisma.reviewComment.create({
      data: { userId, reviewId, content },
      include: { user: { select: { id: true, username: true, name: true } } },
    });
    res.status(201).json({ message: "Komentar berhasil ditambahkan", data: comment });
  } catch (error) {
    res.status(500).json({ error: "Gagal menambahkan komentar", detail: error.message });
  }
};

// DELETE /api/reviews/:id/comments/:commentId  (hanya pemilik komentar)
exports.deleteComment = async (req, res) => {
  try {
    const userId = req.user.userId;
    const reviewId = parseId(req.params.id);
    const commentId = parseId(req.params.commentId);
    if (!reviewId || !commentId) return res.status(400).json({ error: "ID tidak valid" });

    const comment = await prisma.reviewComment.findFirst({ where: { id: commentId, reviewId } });
    if (!comment) return res.status(404).json({ error: "Komentar tidak ditemukan" });
    if (comment.userId !== userId) {
      return res.status(403).json({ error: "Kamu hanya bisa menghapus komentarmu sendiri" });
    }

    await prisma.reviewComment.delete({ where: { id: commentId } });
    res.status(200).json({ message: "Komentar berhasil dihapus" });
  } catch (error) {
    res.status(500).json({ error: "Gagal menghapus komentar", detail: error.message });
  }
};