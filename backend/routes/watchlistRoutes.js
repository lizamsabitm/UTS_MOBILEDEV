const express = require('express');
const router = express.Router();
const watchlistController = require('../controllers/watchlistController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, watchlistController.addToWatchlist);
router.get('/', authMiddleware, watchlistController.getWatchlist);
router.delete('/:tmdbId', authMiddleware, watchlistController.removeFromWatchlist);
router.get('/check/:tmdbId', authMiddleware, watchlistController.checkWatchlist);

module.exports = router;