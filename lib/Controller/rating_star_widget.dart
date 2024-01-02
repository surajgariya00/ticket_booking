import 'package:flutter/material.dart';

class RatingStarsWidget extends StatelessWidget {
  final double? rating;

  const RatingStarsWidget({super.key, this.rating});

  Widget buildStarsAndRating() {
    if (rating == null) {
      return const Text(
        'Rating: N/A',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),
      );
    }

    int fullStars = (rating! ~/ 2).toInt();
    bool hasHalfStar = rating! % 2 != 0;

    List<Widget> starWidgets = List.generate(fullStars, (index) {
      return const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 16.0,
      );
    });

    if (hasHalfStar) {
      starWidgets.add(const Icon(
        Icons.star_half,
        color: Colors.yellow,
        size: 16.0,
      ));
    }

    return Row(
      children: [
        Row(
          children: starWidgets,
        ),
        const SizedBox(width: 4.0),
        Text(
          '${rating!.toStringAsFixed(1)} / 10',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildStarsAndRating();
  }
}
