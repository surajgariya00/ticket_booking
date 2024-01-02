import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ticket_booking/Controller/movie_card.dart';
import 'package:ticket_booking/Controller/movie_search.dart';
import 'package:ticket_booking/Controller/rating_widget.dart';
import 'package:ticket_booking/Model/custom_colors.dart';
import 'package:ticket_booking/Model/ticket_data.dart';
import 'package:ticket_booking/View/movie_detail.dart';
import 'package:ticket_booking/View/signIn_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: MovieSearch(movies, searchMovies, context),
            );
          },
        ),
        backgroundColor: CustomColors.primaryColor,
        title: const Text(
          'Ticket Booking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SignInPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 280.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2.0,
                initialPage: 0,
              ),
              items: movies.map((movie) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsPage(
                              movieId: movie['id'],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 2,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  RatingWidget(
                                    voteAverage:
                                        movie['vote_average'].toDouble(),
                                    voteCount: movie['vote_count'] as int,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Trending',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 420,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.77,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                            movieId: movies[index]['id'],
                          ),
                        ),
                      );
                    },
                    child: MovieCardWidget(movie: movies[index]),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recent View',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 420,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.77,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final sortedMovies = sortMoviesByRating(List.from(movies));

                  return GestureDetector(
                    onTap: () {
                      // checkCurrentUserId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                            movieId: sortedMovies[index]['id'],
                          ),
                        ),
                      );
                    },
                    child: MovieCardWidget(movie: sortedMovies[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchMovies({String? query}) async {
    const apiKey = '6b692b63427c54c00336888a46c856b5';
    var url = Uri.https(
      'api.themoviedb.org',
      '/3/movie/popular',
      {'api_key': apiKey, 'query': query ?? ''},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        movies = jsonDecode(response.body)['results'];
        // print("$movies");
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> searchMovies(String query) async {
    await fetchMovies(query: query);
  }

  List<dynamic> sortMoviesByRating(List<dynamic> movies) {
    movies.sort((a, b) => b['vote_average'].compareTo(a['vote_average']));
    return movies;
  }

  // void checkCurrentUserId() {
  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     ticketBookingData.id = user.uid;

  //     print('Current user ID: ${ticketBookingData.id}');
  //   }
  // }
}
