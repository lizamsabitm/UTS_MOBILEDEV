const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  // Ambil header Authorization dari request
  const authHeader = req.header('Authorization');
  
  if (!authHeader) {
    return res.status(401).json({ error: "Akses ditolak. Token tidak ditemukan." });
  }

  // Header biasanya formatnya "Bearer token_acak_disini", kita pisahkan dan ambil tokennya saja
  const token = authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: "Akses ditolak. Format token salah." });
  }

  try {
    // Verifikasi apakah token tersebut asli buatan server kita
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    
    // Jika asli, simpan data user (seperti userId) ke dalam request untuk dipakai di controller
    req.user = verified; 
    
    // Izinkan masuk ke controller (fitur yang dituju)
    next(); 
  } catch (error) {
    res.status(400).json({ error: "Token tidak valid atau sudah kedaluwarsa." });
  }
};