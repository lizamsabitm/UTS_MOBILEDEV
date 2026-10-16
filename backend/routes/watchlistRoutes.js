const express = require('express');
const router = express.Router();
const watchlistController = require('../controllers/watchlistController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, watchlistController.addToWatchlist);
router.get('/', authMiddleware, watchlistController.getWatchlist);

module.exports = router;