class FallbackReview {
  final String movieTitle;
  final String releaseYear;
  final String posterUrl;
  final String authorName;
  final String authorAvatar;
  final double rating;
  final bool hasHeart;
  final String content;

  const FallbackReview({
    required this.movieTitle,
    required this.releaseYear,
    required this.posterUrl,
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.hasHeart,
    required this.content,
  });
}

class FallbackMovieList {
  final String title;
  final String curatorName;
  final String curatorAvatar;
  final bool isOfficial;
  final List<String> posterUrls;
  final String description;

  const FallbackMovieList({
    required this.title,
    required this.curatorName,
    required this.curatorAvatar,
    this.isOfficial = false,
    required this.posterUrls,
    required this.description,
  });
}

class FallbackSocialData {
  static const List<FallbackReview> popularReviews = [
    FallbackReview(
      movieTitle: 'You Can See Everything',
      releaseYear: '2026',
      posterUrl: 'https://image.tmdb.org/t/p/w342/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg',
      authorName: 'Thomas',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      rating: 5.0,
      hasHeart: true,
      content:
          'Yes it’s about Elizabeth Holmes but really it’s a horror film about power, representation in media, the problem of communication and the existential dread of the unknowability of what really goes on in another persons head.',
    ),
    FallbackReview(
      movieTitle: 'You Can See Everything',
      releaseYear: '2026',
      posterUrl: 'https://image.tmdb.org/t/p/w342/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg',
      authorName: 'James',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      rating: 5.0,
      hasHeart: false,
      content: 'My mouth was agape for basically the entire last two hours',
    ),
    FallbackReview(
      movieTitle: 'Other Mommy',
      releaseYear: '2026',
      posterUrl: 'https://image.tmdb.org/t/p/w342/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
      authorName: 'mak',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      rating: 2.0,
      hasHeart: false,
      content: 'you\'re blatantly just not me mum',
    ),
    FallbackReview(
      movieTitle: 'Digger',
      releaseYear: '2026',
      posterUrl: 'https://image.tmdb.org/t/p/w342/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
      authorName: 'Anne',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      rating: 5.0,
      hasHeart: true,
      content:
          'I loved this brilliant movie. It’s smart and trippy and aggressive and funny and ambitious. It’s worth making the time see and decide for yourself what you make of it. For me? 10/10 🪚',
    ),
    FallbackReview(
      movieTitle: 'Interstellar',
      releaseYear: '2014',
      posterUrl: 'https://image.tmdb.org/t/p/w342/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      authorName: 'Framesofnick',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      rating: 4.5,
      hasHeart: true,
      content: 'Unmatched scale, emotion, and sound design. The docking sequence remains cinema at its absolute finest.',
    ),
  ];

  static const List<FallbackMovieList> popularLists = [
    FallbackMovieList(
      title: 'sapphic horror',
      curatorName: 'soph',
      curatorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      posterUrls: [
        'https://image.tmdb.org/t/p/w185/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg',
        'https://image.tmdb.org/t/p/w185/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
        'https://image.tmdb.org/t/p/w185/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
        'https://image.tmdb.org/t/p/w185/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        'https://image.tmdb.org/t/p/w185/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      ],
      description: 'A curated selection of gothic romance, bloody whispers, and haunting atmospheres across the decades.',
    ),
    FallbackMovieList(
      title: 'Letterboxd\'s Top 500 Films',
      curatorName: 'Official Lists',
      curatorAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      isOfficial: true,
      posterUrls: [
        'https://image.tmdb.org/t/p/w185/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
        'https://image.tmdb.org/t/p/w185/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg',
        'https://image.tmdb.org/t/p/w185/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        'https://image.tmdb.org/t/p/w185/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
        'https://image.tmdb.org/t/p/w185/bXAVVEiQ1222k3r5Fv06f0eC68Y.jpg',
      ],
      description: 'As of October 2026. This list ranks narrative feature films by average member rating across the community.',
    ),
    FallbackMovieList(
      title: 'girl stoner slacker epics',
      curatorName: 'abby',
      curatorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150',
      posterUrls: [
        'https://image.tmdb.org/t/p/w185/dB6Krk806zeqd0YN5T5Q9spIZVH.jpg',
        'https://image.tmdb.org/t/p/w185/5K7cOHoay2mZusSLezBOY0Qxh8a.jpg',
        'https://image.tmdb.org/t/p/w185/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
        'https://image.tmdb.org/t/p/w185/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg',
      ],
      description: 'stumbling, scamming, screaming, and smoking our way through life 🚬',
    ),
    FallbackMovieList(
      title: 'Movies everyone should watch at least once',
      curatorName: 'fcbarcelona',
      curatorAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
      posterUrls: [
        'https://image.tmdb.org/t/p/w185/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
        'https://image.tmdb.org/t/p/w185/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
        'https://image.tmdb.org/t/p/w185/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        'https://image.tmdb.org/t/p/w185/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg',
      ],
      description: 'I asked reddit whats one movie everyone should watch at least once in their lifetime to create a definitive list.',
    ),
  ];
}
