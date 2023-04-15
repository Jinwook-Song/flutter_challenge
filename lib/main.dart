import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class ColorPalette {
  static const white = Color(0xFFFFFFFF);
  static const green = Color(0xFF249f9c);
  static const accentGreen = Color(0xFF037a76);
  static const lightGreen = Color.fromARGB(255, 62, 190, 186);
  static const pink = Color(0xFFf44786);
  static const accentPink = Color(0xFFed1b76);
  static const lightPink = Color(0xFFFF8BBD);
}

class MovieModel {
  final adult,
      backdropPath,
      genreIds,
      id,
      originalLanguage,
      originalTitle,
      overview,
      popularity,
      posterPath,
      releaseDate,
      title,
      video,
      voteAverage,
      voteCount;

  // named constructor
  MovieModel.fromJson(Map<String, dynamic> json)
      : adult = json['adult'],
        backdropPath = json['backdrop_path'],
        genreIds = json['genre_ids'],
        id = json['id'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'],
        posterPath = json['poster_path'],
        releaseDate = json['release_date'],
        title = json['title'],
        video = json['video'],
        voteAverage = json['vote_average'],
        voteCount = json['vote_count'];
}

class MovieGenreModel {
  final List<dynamic> genres;
  MovieGenreModel.fromJson(Map<String, dynamic> json) : genres = json['genres'];
}

class MovieType {
  static const String popular = "popular";
  static const String nowPlaying = "now-playing";
  static const String comingSoon = "coming-soon";
}

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static const String baseImageUrl = "https://image.tmdb.org/t/p/w500/";

  static Future<List<MovieModel>> getMovies(String kind) async {
    List<MovieModel> moviesInstance = [];

    final url = Uri.parse('$baseUrl/$kind');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      final List<dynamic> movies = responseJson['results'];
      for (var movie in movies) {
        moviesInstance.add(MovieModel.fromJson(movie));
      }
      return moviesInstance;
    }
    throw Error();
  }

  static Future<MovieGenreModel> getMovie(int id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic genres = jsonDecode(response.body);
      return MovieGenreModel.fromJson(genres);
    }
    throw Error();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final Future<List<MovieModel>> popularMovies;
  late final Future<List<MovieModel>> nowPlayingMovies;
  late final Future<List<MovieModel>> comingSoonMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = ApiService.getMovies(MovieType.popular);
    nowPlayingMovies = ApiService.getMovies(MovieType.nowPlaying);
    comingSoonMovies = ApiService.getMovies(MovieType.comingSoon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: ColorPalette.accentPink,
                fontWeight: FontWeight.w600,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '● Popular Movies',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 24),
                  makeMovies(
                    movies: popularMovies,
                    aspectRatio: 16 / 9,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '▲ Now in Cinemas',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 24),
                  makeMovies(
                    movies: nowPlayingMovies,
                    aspectRatio: 1,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '■ Comming soon',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 24),
                  makeMovies(
                    movies: comingSoonMovies,
                    aspectRatio: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class makeMovies extends StatelessWidget {
  final double aspectRatio;
  const makeMovies({
    Key? key,
    required this.movies,
    required this.aspectRatio,
  }) : super(key: key);

  final Future<List<MovieModel>> movies;

  void _onMovieTap(BuildContext context, MovieModel movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetail(
          id: movie.id,
          title: movie.title,
          overview: movie.overview,
          voteAverage: movie.voteAverage,
          backdropPath: '${ApiService.baseImageUrl}${movie.backdropPath}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: movies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var movie = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _onMovieTap(context, movie),
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: ColorPalette.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 80,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.jpeg',
                        placeholderFit: BoxFit.cover,
                        image:
                            'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 24,
              ),
            ),
          );
        } else {
          return const SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
      },
    );
  }
}

class MovieDetail extends StatefulWidget {
  final String title, backdropPath, overview;
  final int id;
  final num voteAverage;

  const MovieDetail({
    super.key,
    required this.title,
    required this.backdropPath,
    required this.overview,
    required this.id,
    required this.voteAverage,
  });

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  bool isGreen = Random().nextBool();

  late final int fullStar;
  late final bool hasHalfStar;

  late final Future<MovieGenreModel> genres;

  void _backToHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    genres = ApiService.getMovie(widget.id);
    fullStar = (widget.voteAverage / 2).floor();
    hasHalfStar = (widget.voteAverage / 2 - fullStar).round() == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                widget.backdropPath,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: IconButton(
                      onPressed: () => _backToHome(context),
                      icon: Icon(
                        Icons.chevron_left,
                        size: 36,
                        color: isGreen
                            ? ColorPalette.accentGreen
                            : ColorPalette.accentPink,
                      ),
                    ),
                    title: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isGreen
                            ? ColorPalette.accentGreen
                            : ColorPalette.accentPink,
                        fontSize: 24,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 240),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: isGreen
                          ? ColorPalette.accentPink
                          : ColorPalette.accentGreen,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (var count in [1, 2, 3, 4, 5])
                        Icon(
                          hasHalfStar && count == fullStar + 1
                              ? Icons.star_half
                              : Icons.star,
                          color: count <= (fullStar + (hasHalfStar ? 1 : 0))
                              ? Colors.amber
                              : Colors.grey.shade500,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: genres,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            Text(
                              '2h 14min | ',
                              style: TextStyle(
                                color: isGreen
                                    ? ColorPalette.accentGreen
                                    : ColorPalette.accentPink,
                              ),
                            ),
                            for (var genre in snapshot.data!.genres) ...[
                              Text(
                                '${genre['name']}',
                                style: TextStyle(
                                  color: isGreen
                                      ? ColorPalette.accentGreen
                                      : ColorPalette.accentPink,
                                ),
                              ),
                              const SizedBox(width: 4),
                            ]
                          ],
                        );
                      }
                      return const Text('Loading...');
                    },
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Sotryline',
                    style: TextStyle(
                      color: isGreen
                          ? ColorPalette.accentPink
                          : ColorPalette.accentGreen,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.overview,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: isGreen
                          ? ColorPalette.accentGreen
                          : ColorPalette.accentPink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.15,
            bottom: 40,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              decoration: BoxDecoration(
                  color: isGreen ? ColorPalette.pink : ColorPalette.green,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                child: Text(
                  'Buy ticket',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
