class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory Product.fromRTDB(Map<dynamic, dynamic> data) {
    return Product(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: data['imageUrl']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
    );
  }
}
