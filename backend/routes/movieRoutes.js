const express = require('express');
const router = express.Router();
const movieController = require('../controllers/movieController');

router.get('/popular', movieController.getPopular);
router.get('/search', movieController.search);
router.get('/:id', movieController.getDetail);

module.exports = router;