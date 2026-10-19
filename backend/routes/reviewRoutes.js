const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/reviewController');
const interactionController = require('../controllers/interactionController');
const feedController = require('../controllers/feedController');
const authMiddleware = require('../middlewares/authMiddleware');
const optionalAuth = require('../middlewares/optionalAuth');

router.get('/', optionalAuth, reviewController.getAllReviews);
router.get('/feed', authMiddleware, feedController.getFeed);
router.get('/my', authMiddleware, reviewController.getMyReviews);
router.post('/', authMiddleware, reviewController.addReview);
router.get('/movie/:tmdbId', optionalAuth, reviewController.getReviewsByMovie);

// Like & komentar
router.post('/:id/like', authMiddleware, interactionController.likeReview);
router.delete('/:id/like', authMiddleware, interactionController.unlikeReview);
router.get('/:id/comments', interactionController.getComments);
router.post('/:id/comments', authMiddleware, interactionController.addComment);
router.delete('/:id/comments/:commentId', authMiddleware, interactionController.deleteComment);

module.exports = router;