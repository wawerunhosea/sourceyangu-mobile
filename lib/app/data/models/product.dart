class Product {
  final String name;
  final double price;
  final String? imageUrl;

  Product({required this.name, required this.price, this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(name: json['name'], price: json['price'].toDouble());
  }
}
