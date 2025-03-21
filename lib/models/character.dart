class Character {
  final String id;
  final String name;
  final String description;
  final String avatar;
  final String backgroundImage;
  final List<String> tags;
  final int price;
  final int chatCount;
  final double rating;
  final String category;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.avatar,
    required this.backgroundImage,
    required this.tags,
    required this.price,
    this.chatCount = 0,
    this.rating = 0.0,
    required this.category,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      avatar: json['avatar'],
      backgroundImage: json['background_image'],
      tags: List<String>.from(json['tags']),
      price: json['price'],
      chatCount: json['chat_count'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'background_image': backgroundImage,
      'tags': tags,
      'price': price,
      'chat_count': chatCount,
      'rating': rating,
      'category': category,
    };
  }
}
