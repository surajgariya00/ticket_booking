import 'package:flutter/material.dart';
import 'package:ticket_booking/Controller/rating_star_widget.dart';
import 'package:ticket_booking/Model/custom_colors.dart';

class MovieCardWidget extends StatelessWidget {
  final dynamic movie;

  const MovieCardWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: CustomColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.7,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: movie['poster_path'] != null
                  ? AspectRatio(
                      aspectRatio: 0.7,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Icon(Icons.movie),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: CustomColors.secondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                RatingStarsWidget(rating: movie['vote_average'].toDouble()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
