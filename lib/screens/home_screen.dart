import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../state/app_state.dart';
import '../utils/app_colors.dart';
import '../widgets/recipe_card.dart';
import 'all_recipes_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final allRecipes = appState.recipes;
    final categories = appState.categories;
    final activeCategory =
        categories.contains(_selectedCategory) ? _selectedCategory : 'All';

    final filtered = AppState.filterRecipes(
      recipes: allRecipes,
      query: _searchQuery,
      category: activeCategory,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  // Only show banner when not searching
                  if (_searchQuery.isEmpty) ...[
                    _buildPromotionalBanner(),
                    const SizedBox(height: 24),
                  ],
                  _buildCategories(categories, activeCategory),
                  const SizedBox(height: 24),
                  _buildRecipeSection(context, appState, filtered),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hello there!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'What are you cooking today?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Stack(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2. Search Bar — functional with TextField
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.searchBarBg,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search any recipes',
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textLight,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textLight,
                  size: 22,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textLight,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionalBanner() {
    return Container(
      width: double.infinity,
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF14A380),
            Color(0xFF0E7A60),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Cook the best\nrecipes at home',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&auto=format&fit=crop&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.white24,
                              child: const Icon(
                                Icons.restaurant_menu_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  /// 4. Categories (dynamically derived from loaded recipes)
  Widget _buildCategories(List<String> categories, String selectedCategory) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected =
              cat.toLowerCase() == selectedCategory.toLowerCase();
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 5. Recipe section (search-aware, real-time aware)
  Widget _buildRecipeSection(
    BuildContext context,
    AppState appState,
    List<RecipeModel> filtered,
  ) {
    final sectionTitle = _searchQuery.isNotEmpty
        ? 'Results for "$_searchQuery"'
        : 'Quick & Easy';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                sectionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (_searchQuery.isEmpty && filtered.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AllRecipesScreen(),
                    ),
                  );
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (appState.isLoading && appState.recipes.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (appState.hasError && appState.recipes.isEmpty)
          _buildErrorState(appState)
        else if (appState.recipes.isEmpty)
          _buildEmptyFirestore()
        else if (filtered.isEmpty)
          _buildNoResults()
        else if (_searchQuery.isNotEmpty)
          // Show vertical list when searching
          Column(
            children: filtered
                .map((recipe) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildSearchResultCard(recipe),
                    ))
                .toList(),
          )
        else
          // Horizontal card list (original design)
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return RecipeCard(recipe: filtered[index], width: 185);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Color(0xFFFF4D4F)),
            const SizedBox(height: 12),
            const Text(
              'Unable to load recipes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              appState.errorMessage ??
                  'Please check your connection and Firebase setup.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => appState.retryLoading(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFirestore() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: const [
            Icon(Icons.restaurant_menu_rounded,
                size: 60, color: AppColors.textLight),
            SizedBox(height: 12),
            Text(
              'No recipes in Firestore yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Add recipe documents to your "recipes" collection.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: const [
            Icon(Icons.search_off_rounded,
                size: 60, color: AppColors.textLight),
            SizedBox(height: 12),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Try a different name or category',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Search result card (vertical layout)
  Widget _buildSearchResultCard(RecipeModel recipe) {
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
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                recipe.imageUrl,
                width: 100,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  width: 100,
                  height: 90,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.fastfood_rounded,
                      color: AppColors.primary, size: 32),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(recipe.category,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded,
                            size: 13, color: AppColors.secondary),
                        const SizedBox(width: 3),
                        Text('${recipe.calories} Kcal',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        const Icon(Icons.schedule_rounded,
                            size: 13, color: AppColors.primary),
                        const SizedBox(width: 3),
                        Text('${recipe.cookingTimeMinutes} Min',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => appState.toggleFavorite(recipe.id),
                child: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav
                      ? const Color(0xFFFF4D4F)
                      : AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
