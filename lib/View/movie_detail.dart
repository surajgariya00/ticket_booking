import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_booking/Controller/ticket_booking_data.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  Map<String, dynamic> movieDetails = {};

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Movie Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movieDetails['poster_path'] != null)
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w300${movieDetails['poster_path']}',
                    width: double.infinity,
                    height: 400.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              'Title: ${movieDetails['title'] ?? 'N/A'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Overview: ${movieDetails['overview'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Release Date: ${movieDetails['release_date'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Popularity: ${movieDetails['popularity'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _bookTicket(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Book Tickets',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
