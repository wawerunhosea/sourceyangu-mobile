class Product {
  final String id;
  final String brand;
  final List<String> careInstruction;
  final String category;
  final String design;
  final List<String> images;
  final bool inStock;
  final String material;
  final String occasion;
  final List<dynamic> onOffer; // mix of bool and strings
  final String pattern;
  final List<String> price;
  final String primaryColor;
  final List<String> secondaryColor;
  final String shopId;
  final List<String> sizes;
  final List<String> stockQuantity;
  final List<String> tags;
  final String targetClients;
  final String sleeveLength;
  final String type;

  // Optional enhancements
  final double? rating; // ⭐ user rating
  final bool isFavorite; // ❤️ saved by user
  final bool isConsidering; // 👀 soft interest
  final bool isExactMatch; // ✅ match tier flag

  Product({
    required this.id,
    required this.brand,
    required this.careInstruction,
    required this.category,
    required this.design,
    required this.images,
    required this.inStock,
    required this.material,
    required this.occasion,
    required this.onOffer,
    required this.pattern,
    required this.price,
    required this.primaryColor,
    required this.secondaryColor,
    required this.shopId,
    required this.sizes,
    required this.stockQuantity,
    required this.tags,
    required this.targetClients,
    required this.rating,
    this.isFavorite = false,
    this.isConsidering = false,
    required this.isExactMatch,
    required this.sleeveLength,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      design: json['design'] ?? '',
      material: json['material'] ?? '',
      occasion: json['occasion'] ?? '',
      pattern: json['pattern'] ?? '',
      primaryColor: json['primaryColor'] ?? '',
      shopId: json['shopId'] ?? '',
      sleeveLength: json['sleeveLength'] ?? '',
      type: json['type'] ?? '',
      targetClients: json['targetClients'] ?? '',
      price: List<String>.from(json['price'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      stockQuantity: List<String>.from(json['stockQuantity'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      secondaryColor: List<String>.from(json['secondaryColor'] ?? []),
      careInstruction: List<String>.from(json['careInstruction'] ?? []),
      onOffer: List<dynamic>.from(json['onOffer'] ?? []),
      inStock: json['inStock'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      isConsidering: json['isConsidering'] ?? false,
      isExactMatch: json['isExactMatch'] ?? false,
      rating:
          (json['score'] != null) ? (json['score'] as num).toDouble() : null,
    );
  }
}
