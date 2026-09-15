class MockRecipe {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final int calories;
  final int cookingTimeMinutes;
  bool isFavorite;


  MockRecipe({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.calories,
    required this.cookingTimeMinutes,
    this.isFavorite = false,
  });

  static List<MockRecipe> getSampleRecipes() {
    return [
      MockRecipe(
        id: '1',
        name: 'Creamy Tomato Pasta',
        category: 'Dinner',
        imageUrl:
            'https://images.unsplash.com/photo-1621996346565-e3d5d6281699?w=600&auto=format&fit=crop&q=80',
        calories: 320,
        cookingTimeMinutes: 20,
        isFavorite: true,
      ),
      MockRecipe(
        id: '2',
        name: 'Spicy Chicken Curry',
        category: 'Lunch',
        imageUrl:
            'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80',
        calories: 450,
        cookingTimeMinutes: 35,
        isFavorite: false,
      ),
      MockRecipe(
        id: '3',
        name: 'Avocado Egg Toast',
        category: 'Breakfast',
        imageUrl:
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&auto=format&fit=crop&q=80',
        calories: 220,
        cookingTimeMinutes: 10,
        isFavorite: false,
      ),
      MockRecipe(
        id: '4',
        name: 'Fresh Garden Salad',
        category: 'Lunch',
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop&q=80',
        calories: 160,
        cookingTimeMinutes: 15,
        isFavorite: true,
      ),
      MockRecipe(
        id: '5',
        name: 'Grilled Salmon Bowl',
        category: 'Dinner',
        imageUrl:
            'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&auto=format&fit=crop&q=80',
        calories: 410,
        cookingTimeMinutes: 25,
        isFavorite: false,
      ),
    ];
  }
}
