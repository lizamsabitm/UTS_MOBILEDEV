// features/home/data/movie_model.dart

class CastMember {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;

  CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  String? get fullProfileUrl {
    if (profilePath == null || profilePath!.isEmpty) return null;
    if (profilePath!.startsWith('http')) return profilePath;
    return 'https://image.tmdb.org/t/p/w185$profilePath';
  }

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'],
      profilePath: json['profile_path'] ?? json['profilePath'],
    );
  }
}

class Movie {
  final int id; // tmdbId
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final String? releaseDate;
  final double? rating;
  final String? tagline;
  final int? runtime;
  final String? director;
  final List<CastMember> cast;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.releaseDate,
    this.rating,
    this.tagline,
    this.runtime,
    this.director,
    this.cast = const [],
    this.genres = const ['Drama', 'Thriller', 'Mystery'],
  });

  String? get fullPosterUrl {
    if (posterPath == null || posterPath!.isEmpty) return null;
    if (posterPath!.startsWith('http')) return posterPath;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String? get fullBackdropUrl {
    if (backdropPath == null || backdropPath!.isEmpty) return null;
    if (backdropPath!.startsWith('http')) return backdropPath;
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }

  String get releaseYear {
    if (releaseDate != null && releaseDate!.length >= 4) {
      return releaseDate!.substring(0, 4);
    }
    return '';
  }

  String get formattedRuntime {
    if (runtime == null || runtime == 0) return '';
    return '$runtime mins';
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    String? foundDirector;
    List<CastMember> castList = [];
    List<String> genreList = [];

    if (json['genres'] is List) {
      genreList = (json['genres'] as List)
          .map((g) => g is Map ? (g['name']?.toString() ?? '') : g.toString())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (genreList.isEmpty) {
      genreList = ['Drama', 'Thriller', 'Mystery'];
    }

    if (json['credits'] != null && json['credits'] is Map) {
      final credits = json['credits'] as Map<String, dynamic>;
      if (credits['crew'] is List) {
        final crew = credits['crew'] as List;
        for (var member in crew) {
          if (member is Map && (member['job'] == 'Director' || member['department'] == 'Directing')) {
            foundDirector = member['name'];
            break;
          }
        }
      }
      if (credits['cast'] is List) {
        castList = (credits['cast'] as List)
            .take(15)
            .map((c) => CastMember.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    }

    return Movie(
      id: json['id'] ?? json['tmdbId'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'] ?? json['posterPath'],
      backdropPath: json['backdrop_path'] ?? json['backdropPath'],
      overview: json['overview'] ?? json['summary'],
      releaseDate: json['release_date'] ?? json['releaseDate'],
      rating: (json['vote_average'] != null) ? (json['vote_average'] as num).toDouble() : null,
      tagline: json['tagline'],
      runtime: json['runtime'],
      director: foundDirector ?? json['director'],
      cast: castList,
      genres: genreList,
    );
  }

  static List<Movie> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
