import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import '../../utils/app_constants.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/recipe_card.dart';
import 'all_recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
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

                /// Categories
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

                /// Title
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

                /// Loading
                if (recipeProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  )

                /// No Data
                else if (recipeProvider.recipes.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "No recipes found.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )

                /// Firebase Recipes
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: recipeProvider.recipes.map((recipe) {
                        return RecipeCard(
                          title: recipe.name,
                          calories: "${recipe.calories} kcal",
                          time: "${recipe.cookingTime} min",
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}