import 'package:flutter/material.dart';
import 'package:flutter_challenge/constants/color_palette.dart';
import 'package:flutter_challenge/main.dart';
import 'package:flutter_challenge/models/movie_model.dart';
import 'package:flutter_challenge/services/api.dart';
import 'package:flutter_challenge/widgets/movie_cards.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  MovieCards(
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
                  MovieCards(
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
                  MovieCards(
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
