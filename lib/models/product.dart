import 'dart:convert';

class Product {
  final String uuid;
  final String name;
  // FIXME Le champs peut-être null donc String?
  final String description;
  final double price;
  final String image;

  Product({
    required this.uuid,
    required this.name,
    // FIXME La description peut être null donc pas besoin du required
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // FIXME Sur le swagger on utilise la propriété id. Il faut garder une certaine coherence. De plus, tu définis tous les champs à chaine vide
      uuid: json['uuid'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // FIXME Tu castes en num puis tu converties en double. Tu as juste à faire price: json['price'] vu que l'api renvoie un nombre. Tu peux declaré le type num dans ta classe
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

  // FIXME La logique du decode ne devrait pas être ici. Elle devrait être dans le service. Ici tu devrais juste assigner la Map à la classe Product
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
