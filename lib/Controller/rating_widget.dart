import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double voteAverage;
  final int voteCount;

  const RatingWidget({
    super.key,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
        Text(
          '${voteAverage.toStringAsFixed(1)}/10',
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          '$voteCount Reviews',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
