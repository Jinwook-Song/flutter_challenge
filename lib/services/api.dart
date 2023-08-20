import 'dart:convert';

import 'package:flutter_challenge/models/movie_model.dart';
import 'package:http/http.dart' as http;

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
