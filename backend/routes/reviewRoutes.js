const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/reviewController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/', reviewController.getAllReviews);
router.get('/my', authMiddleware, reviewController.getMyReviews);
router.post('/', authMiddleware, reviewController.addReview);
router.get('/movie/:tmdbId', reviewController.getReviewsByMovie);

module.exports = router;