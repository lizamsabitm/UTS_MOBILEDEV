// Include standar untuk review + data sosial (jumlah like/komentar, status like oleh viewer)
const reviewInclude = (viewerId) => ({
  movie: true,
  user: { select: { id: true, username: true, name: true } },
  _count: { select: { likes: true, comments: true } },
  likes: { where: { userId: viewerId || -1 }, select: { userId: true } },
});

// Ubah hasil Prisma menjadi JSON yang rapi untuk Flutter
const serializeReview = (review) => {
  const { _count, likes, ...rest } = review;
  return {
    ...rest,
    likeCount: _count ? _count.likes : 0,
    commentCount: _count ? _count.comments : 0,
    likedByMe: Array.isArray(likes) && likes.length > 0,
  };
};

module.exports = { reviewInclude, serializeReview };