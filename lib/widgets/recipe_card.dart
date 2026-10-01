import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../screens/recipe_detail_screen.dart';
import '../state/app_state.dart';
import '../utils/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final double? width;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final isFav = context.watch<AppState>().isFavorite(recipe.id);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image with Heart Icon Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 125,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.fastfood_rounded,
                            size: 40,
                            color: AppColors.textLight,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => appState.toggleFavorite(recipe.id),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav
                            ? const Color(0xFFFF4D4F)
                            : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Name
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Category label
                  Text(
                    recipe.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Calories & Cooking time
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${recipe.calories} Kcal',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${recipe.cookingTimeMinutes} Min',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
