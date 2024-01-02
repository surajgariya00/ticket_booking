import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_booking/Model/ticket_data.dart';
import 'package:ticket_booking/View/movie_detail.dart';

class MovieSearch extends SearchDelegate<String> {
  final List<dynamic> movies;
  final Function(String) onSearch;
  final BuildContext context;

  MovieSearch(this.movies, this.onSearch, this.context);

  Future<void> addToSearchHistory(String movieTitle) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('searchHistory')
          .add({
        'query': movieTitle,
        'timestamp': DateTime.now(),
      });
    }
  }

  void navigateToMovieDetails(BuildContext context, int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movieId: movieId),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestedMovies = query.isEmpty
        ? []
        : movies
            .where((movie) => movie['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return buildSearchResults(suggestions: suggestedMovies);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return buildSearchHistory();
    } else {
      final suggestionList = movies
          .where((movie) => movie['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      return buildSearchResults(suggestions: suggestionList);
    }
  }

  Widget buildSearchResults({List<dynamic>? suggestions}) {
    final searchResults = suggestions ?? movies;

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        if (searchResults[index] is Map<String, dynamic>) {
          final movieId = searchResults[index]['id'];

          return Card(
            elevation: 5,
            shadowColor: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.grey[900],
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${searchResults[index]['poster_path']}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                searchResults[index]['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                navigateToMovieDetails(context, movieId);
                addToSearchHistory(searchResults[index]['title']);
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget buildSearchHistory() {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: userId != null
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('searchHistory')
              .orderBy('timestamp', descending: true)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No search history found.'),
          );
        } else {
          final history =
              snapshot.data!.docs.map((doc) => doc['query']).toList();
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                title: Text(
                  history[index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  onSearch(history[index]);
                  close(context, '');
                },
              );
            },
          );
        }
      },
    );
  }
}
