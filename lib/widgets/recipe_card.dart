import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String calories;
  final String time;

  const RecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(calories),
            Text(time),
          ],
        ),
      ),
    );
  }
}