class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  bool isFavorite;
  final String description;
  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.isFavorite = false,
     required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
    );
  }
}
