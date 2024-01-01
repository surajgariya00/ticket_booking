// import 'package:flutter/material.dart';

// class MovieCard extends StatelessWidget {
//   final dynamic movie;

//   const MovieCard({Key? key, required this.movie}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 0.7,
//             child: ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
//               child: movie['poster_path'] != null
//                   ? AspectRatio(
//                       aspectRatio: 0.7,
//                       child: Image.network(
//                         'https://image.tmdb.org/t/p/w300${movie['poster_path']}',
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   : SizedBox(
//                       width: double.infinity,
//                       height: double.infinity,
//                       child: Icon(Icons.movie),
//                     ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(8.0),
//             height: 60, // Adjust height as needed
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       width: double.infinity,
//                       child: Text(
//                         movie['title'],
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Text(
//                     'Release Date: ${movie['release_date']}',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12.0,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
