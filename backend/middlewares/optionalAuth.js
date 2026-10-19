const jwt = require('jsonwebtoken');

// Mirip authMiddleware, tetapi TIDAK menolak request tanpa token.
// Dipakai untuk endpoint publik yang ingin tahu "siapa yang melihat" (mis. likedByMe).
module.exports = (req, res, next) => {
  const authHeader = req.header('Authorization');
  const token = authHeader ? authHeader.split(' ')[1] : null;

  if (token) {
    try {
      req.user = jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      // Token tidak valid -> perlakukan sebagai tamu, jangan blokir request
    }
  }
  next();
};