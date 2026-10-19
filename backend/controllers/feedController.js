const { PrismaClient } = require('@prisma/client');
const { reviewInclude, serializeReview } = require('../utils/reviewSerializer');
const prisma = new PrismaClient();

// GET /api/reviews/feed?limit=20&cursor=<reviewId>
// Review terbaru dari user yang diikuti oleh user yang sedang login.
exports.getFeed = async (req, res) => {
  try {
    const userId = req.user.userId;
    const limit = Math.min(parseInt(req.query.limit, 10) || 20, 50);
    const cursor = parseInt(req.query.cursor, 10);

    const reviews = await prisma.review.findMany({
      // User.followers = baris Follows yang menunjuk ke user tsb (pengikutnya)
      where: { user: { followers: { some: { followerId: userId } } } },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
      include: reviewInclude(userId),
    });

    res.status(200).json({
      data: reviews.map(serializeReview),
      nextCursor: reviews.length === limit ? reviews[reviews.length - 1].id : null,
    });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil activity feed", detail: error.message });
  }
};