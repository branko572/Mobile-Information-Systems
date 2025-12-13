class Meal {
  final String id;
  final String name;
  final String imageUrl;
  bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? 'Unknown',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'isFavorite': isFavorite,
  };
}
