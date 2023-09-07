import 'package:flutter/material.dart';
import 'package:flutter_challenge/constants/color_palette.dart';
import 'package:flutter_challenge/models/movie_model.dart';
import 'package:flutter_challenge/services/api.dart';

class MovieDetail extends StatefulWidget {
  final String title, backdropPath, overview;
  final int id;
  final num voteAverage;
  final String movieType;

  const MovieDetail({
    super.key,
    required this.title,
    required this.backdropPath,
    required this.overview,
    required this.id,
    required this.voteAverage,
    required this.movieType,
  });

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late final int fullStar;
  late final bool hasHalfStar;

  late final Future<MovieGenreModel> genres;
  late final NetworkImage networkImage;

  void _backToHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    genres = ApiService.getMovie(widget.id);
    networkImage = NetworkImage(widget.backdropPath);
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
              opacity: 0.1,
              child: Hero(
                tag: '${widget.movieType}_${widget.id}',
                child: Image(
                  image: networkImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
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
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 36,
                        color: ColorPalette.accentPink,
                      ),
                    ),
                    title: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorPalette.accentPink,
                        fontSize: 24,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 180),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: ColorPalette.accentGreen,
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
                        final runtime = snapshot.data!.runtime;
                        final hour = (runtime / 60).round();
                        final min = runtime % 60;
                        return Row(
                          children: [
                            Text(
                              '${hour}h ${min}min | ',
                              style: const TextStyle(
                                color: ColorPalette.accentGreen,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data!.genres
                                    .map((genre) => genre['name'])
                                    .toString()
                                    .replaceAll('(', '')
                                    .replaceAll(')', ''),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorPalette.accentGreen,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const Text(
                        'Loading...',
                        style: TextStyle(color: Colors.amber),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Sotryline',
                    style: TextStyle(
                      color: ColorPalette.accentPink,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: ColorPalette.accentPink,
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
                  color: ColorPalette.pink,
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
