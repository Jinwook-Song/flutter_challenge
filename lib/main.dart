import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class ColorPalette {
  static const white = Color(0xFFFFFFFF);
  static const green = Color(0xFF249f9c);
  static const accentGreen = Color(0xFF037a76);
  static const pink = Color(0xFFf44786);
  static const accentPink = Color(0xFFed1b76);
}

class MovieModel {
  final adult,
      backdrop_path,
      genre_ids,
      id,
      original_language,
      original_title,
      overview,
      popularity,
      poster_path,
      release_date,
      title,
      video,
      vote_average,
      vote_count;

  // named constructor
  MovieModel.fromJson(Map<String, dynamic> json)
      : adult = json['adult'],
        backdrop_path = json['backdrop_path'],
        genre_ids = json['genre_ids'],
        id = json['id'],
        original_language = json['original_language'],
        original_title = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'],
        poster_path = json['poster_path'],
        release_date = json['release_date'],
        title = json['title'],
        video = json['video'],
        vote_average = json['vote_average'],
        vote_count = json['vote_count'];
}

class MovieType {
  static const String popular = "popular";
  static const String nowPlaying = "now-playing";
  static const String comingSoon = "coming-soon";
}

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";

  static Future<List<MovieModel>> getMovies(String kind) async {
    List<MovieModel> moviesInstance = [];

    final url = Uri.parse('$baseUrl/$kind');
    print(url);

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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: (ColorPalette.green),
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

  static const movies = [1, 2, 3, 4, 5, 6, 7, 8, 9];
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
                return AspectRatio(
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
                          'https://image.tmdb.org/t/p/w500/${movie.poster_path}',
                      fit: BoxFit.cover,
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
