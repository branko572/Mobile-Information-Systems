class Category {
  final String id;
  final String name;
  final String thumbnail;
  bool isFavorite;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.isFavorite = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? 'Unknown',
      thumbnail: json['strCategoryThumb'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'thumbnail': thumbnail,
    'isFavorite': isFavorite,
  };
}
