const axios = require('axios');

const TMDB_BASE_URL = 'https://api.themoviedb.org/3';
const API_KEY = process.env.TMDB_API_KEY;

// Fungsi mengambil film populer (Untuk Beranda)
exports.getPopularMovies = async () => {
  const response = await axios.get(`${TMDB_BASE_URL}/movie/popular`, {
    params: { api_key: API_KEY, language: 'en-US', page: 1 }
  });
  return response.data.results;
};

// Fungsi pencarian film
exports.searchMovies = async (query) => {
  const response = await axios.get(`${TMDB_BASE_URL}/search/movie`, {
    params: { api_key: API_KEY, language: 'en-US', query: query, page: 1 }
  });
  return response.data.results;
};

// Fungsi detail film spesifik
exports.getMovieDetails = async (tmdbId) => {
  const response = await axios.get(`${TMDB_BASE_URL}/movie/${tmdbId}`, {
    params: { api_key: API_KEY, language: 'en-US', append_to_response: 'credits'}
  });
  return response.data;
};