const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const followController = require('../controllers/followController');
const authMiddleware = require('../middlewares/authMiddleware');

// Pasang authMiddleware sebelum controller getProfile
router.get('/profile', authMiddleware, userController.getProfile);
router.put('/profile', authMiddleware, userController.updateProfile);

// PENTING: rute statis ('/search') harus SEBELUM rute dinamis ('/:id')
router.get('/search', authMiddleware, userController.searchUsers);

router.get('/:id', authMiddleware, userController.getPublicProfile);
router.get('/:id/followers', authMiddleware, followController.getFollowers);
router.get('/:id/following', authMiddleware, followController.getFollowing);
router.post('/:id/follow', authMiddleware, followController.followUser);
router.delete('/:id/follow', authMiddleware, followController.unfollowUser);

module.exports = router;