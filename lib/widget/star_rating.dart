import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int numberOfStars;

  const StarRating({Key? key, required this.numberOfStars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    Widget activeStar = const Icon(
      Icons.star,
      color: Colors.amber,
    );
    Widget inActiveStar = Icon(
      Icons.star,
      color: Colors.grey.withOpacity(0.4),
    );

    for (int i = 0; i < 5; i++) {
      if (i >= numberOfStars) {
        stars.add(inActiveStar);
      } else {
        stars.add(activeStar);
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }
}
