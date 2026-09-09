import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/recipe_card.dart';
import 'all_recipes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "What are you\ncooking today?",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const CustomSearchBar(),

                const SizedBox(height: 20),

                const HomeBanner(),

                const SizedBox(height: 25),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(
                        title: "All",
                        isSelected: true,
                      ),
                      CategoryChip(title: "Breakfast"),
                      CategoryChip(title: "Lunch"),
                      CategoryChip(title: "Dinner"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quick & Easy",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AllRecipesScreen(),
    ),
  );
},
                      child: const Text("View All"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
                    ],
                  ),
                ),

                // Bottom Navigation 
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}