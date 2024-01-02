import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_booking/Controller/rating_star_widget.dart';
import 'package:ticket_booking/Controller/ticket_booking_data.dart';
import 'package:ticket_booking/Model/custom_colors.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  MovieDetailsPageState createState() => MovieDetailsPageState();
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  Map<String, dynamic> movieDetails = {};

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    String titleWithYear = movieDetails['title'] ?? 'N/A';
    if (movieDetails['release_date'] != null) {
      final releaseDate = DateTime.parse(movieDetails['release_date']);
      // print('$releaseDate');
      final year = releaseDate.year;
      titleWithYear += ' ($year)';
    }
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4.3 / 5,
            child: Stack(
              children: [
                if (movieDetails['poster_path'] != null)
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          const Color.fromARGB(255, 36, 36, 36)
                              .withOpacity(0.9),
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w300${movieDetails['poster_path']}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleWithYear,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          RatingStarsWidget(
                            rating: (movieDetails['vote_average'] != null)
                                ? movieDetails['vote_average'].toDouble()
                                : null,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${movieDetails['overview'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    _bookTicket(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Book Tickets',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> fetchMovieDetails() async {
    const apiKey = "6b692b63427c54c00336888a46c856b5";
    var url = Uri.https(
      'api.themoviedb.org',
      '/3/movie/${widget.movieId}',
      {'api_key': apiKey},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = jsonDecode(response.body);
        // print('$movieDetails');
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  void _bookTicket(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketBookingPage(movieDetails: movieDetails),
      ),
    );
  }
}
