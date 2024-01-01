import 'package:flutter/material.dart';
import 'package:ticket_booking/View/movie_detail.dart';

class MovieSearch extends SearchDelegate<String> {
  final List<dynamic> movies;
  final Function(String) onSearch;
  final BuildContext context;

  MovieSearch(this.movies, this.onSearch, this.context);

  List<String> searchHistory = [
    'Action',
    'Adventure',
    'Comedy',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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

    return _buildSearchResults(suggestions: suggestedMovies);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? searchHistory
        : movies
            .where((movie) => movie['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return _buildSearchResults(suggestions: suggestionList);
  }

  Widget _buildSearchResults({List<dynamic>? suggestions}) {
    final searchResults = suggestions ?? movies;

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        if (searchResults[index] is String) {
          return ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            title: Text(
              searchResults[index],
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              onSearch(searchResults[index]);
              close(context, '');
            },
          );
        } else if (searchResults[index] is Map<String, dynamic>) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsPage(
                    movieId: searchResults[index]['id'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w300${searchResults[index]['poster_path']}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchResults[index]['title'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Release Date: ${searchResults[index]['release_date']}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
