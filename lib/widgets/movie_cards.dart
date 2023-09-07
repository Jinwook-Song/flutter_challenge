import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/movie_model.dart';
import 'package:flutter_challenge/services/api.dart';
import 'package:flutter_challenge/views/movie_detail_screen.dart';

class MovieCards extends StatelessWidget {
  final double aspectRatio;
  final String movieType;
  const MovieCards({
    Key? key,
    required this.movies,
    required this.aspectRatio,
    required this.movieType,
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
          movieType: movieType,
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
                  child: Hero(
                    tag: '${movieType}_${movie.id}',
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 80,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.jpeg',
                          placeholderFit: BoxFit.cover,
                          image:
                              'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 24,
                );
              },
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
