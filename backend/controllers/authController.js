const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// Fungsi Registrasi
exports.register = async (req, res) => {
  try {
    const { email, username, password, name } = req.body;

    // Cek apakah email atau username sudah terdaftar
    const existingUser = await prisma.user.findFirst({
      where: { OR: [{ email }, { username }] }
    });
    if (existingUser) {
      return res.status(400).json({ error: "Email atau username sudah digunakan" });
    }

    // Enkripsi password dengan bcrypt sebelum disimpan
    const hashedPassword = await bcrypt.hash(password, 10);

    // Simpan data ke database
    const newUser = await prisma.user.create({
      data: { email, username, password: hashedPassword, name }
    });

    res.status(201).json({ message: "Registrasi berhasil", userId: newUser.id });
  } catch (error) {
    res.status(500).json({ error: "Gagal registrasi", detail: error.message });
  }
};

// Fungsi Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Cari user berdasarkan email atau username
    const user = await prisma.user.findFirst({
      where: {
        OR: [{ email: email }, { username: email }]
      }
    });
    if (!user) {
      return res.status(404).json({ error: "Pengguna tidak ditemukan" });
    }

    // Cocokkan password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: "Password salah" });
    }

    // Buat token JWT yang akan melindungi endpoint lain
    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, { expiresIn: '7d' });

    res.status(200).json({
      message: "Login berhasil",
      token,
      username: user.username,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        name: user.name
      }
    });
  } catch (error) {
    res.status(500).json({ error: "Gagal login", detail: error.message });
  }
};