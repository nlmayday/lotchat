class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final int likes;
  final int stars;
  final int coins;

  BannerItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.likes,
    required this.stars,
    required this.coins,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      description: json['description'],
      likes: json['likes'],
      stars: json['stars'],
      coins: json['coins'],
    );
  }
}