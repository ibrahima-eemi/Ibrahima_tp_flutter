import 'dart:convert';

class Product {
  final String uuid;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    required this.uuid,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    uuid: json['uuid'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] as num).toDouble(),
    image: json['image'] ?? '',
  );
}

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'image': image,
  };

  static List<Product> listFromJson(String jsonData) {
    final Map<String, dynamic> parsed = json.decode(jsonData);
    final rows = parsed['rows'];
    if (rows is List) {
      return rows.map((item) => Product.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
