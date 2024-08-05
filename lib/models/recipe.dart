class Recipe {
  final int? id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String? imagePath;
  final String category;
  final double? rating;
  bool isFavorite;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.imagePath,
    required this.category,
    this.rating,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients.join(', '),
      'instructions': instructions,
      'imagePath': imagePath,
      'category': category,
      'rating': rating,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      ingredients: (map['ingredients'] as String).split(', '),
      instructions: map['instructions'],
      imagePath: map['imagePath'],
      category: map['category'],
      rating: map['rating'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
