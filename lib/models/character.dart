class Character {
  final String id;
  final String name;
  final String description;
  final String avatar;
  final String backgroundImage;
  final List<String> tags;
  final int price;
  final String category;
  final int chatCount;
  final double rating;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.avatar,
    required this.backgroundImage,
    required this.tags,
    required this.price,
    required this.category,
    required this.chatCount,
    required this.rating,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      avatar: json['avatar'] as String,
      backgroundImage: json['backgroundImage'] as String,
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      price: json['price'] as int,
      category: json['category'] as String,
      chatCount: json['chatCount'] as int,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'backgroundImage': backgroundImage,
      'tags': tags,
      'price': price,
      'category': category,
      'chatCount': chatCount,
      'rating': rating,
    };
  }
}
