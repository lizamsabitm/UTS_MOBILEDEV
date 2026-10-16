const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middlewares/authMiddleware');

// Pasang authMiddleware sebelum controller getProfile
router.get('/profile', authMiddleware, userController.getProfile);

module.exports = router;