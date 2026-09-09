import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../../widgets/recipe_card.dart';

class AllRecipesScreen extends StatelessWidget {
  const AllRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Recipes"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.68,
          children: const [
            RecipeCard(
              title: "Chicken Curry",
              calories: "250 kcal",
              time: "30 min",
            ),
            RecipeCard(
              title: "French Toast",
              calories: "180 kcal",
              time: "15 min",
            ),
            RecipeCard(
              title: "Mexican Pizza",
              calories: "320 kcal",
              time: "40 min",
            ),
            RecipeCard(
              title: "Beef Steak",
              calories: "450 kcal",
              time: "50 min",
            ),
          ],
        ),
      ),
    );
  }
}