const tmdbService = require('../services/tmdbService');

exports.getPopular = async (req, res) => {
  try {
    const movies = await tmdbService.getPopularMovies();
    res.status(200).json({ data: movies });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil film populer dari TMDB" });
  }
};

exports.search = async (req, res) => {
  try {
    const query = req.query.q;
    if (!query) return res.status(400).json({ error: "Parameter pencarian (q) wajib diisi" });
    
    const movies = await tmdbService.searchMovies(query);
    res.status(200).json({ data: movies });
  } catch (error) {
    res.status(500).json({ error: "Gagal mencari film" });
  }
};

exports.getDetail = async (req, res) => {
  try {
    const tmdbId = req.params.id;
    const movie = await tmdbService.getMovieDetails(tmdbId);
    res.status(200).json({ data: movie });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil detail film" });
  }
};