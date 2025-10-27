import 'package:sourceyangu/app/data/models/product.dart';

String extractPrice(Product product) {
  final raw = product.price.firstWhere(
    (p) => p.contains(product.sizes.first),
    orElse: () => '',
  );
  final parts = raw.split('.');
  return parts.length >= 3 ? parts[3] : '—';
}

List<String> extractImageUrls(List<String> rawImages) {
  return rawImages
      .map((raw) {
        final match = RegExp(r'https:\/\/[^\s]+').firstMatch(raw);
        return match?.group(0) ?? '';
      })
      .where((url) => url.isNotEmpty)
      .toList();
}

class ProductVariantImage {
  final String primaryColor;
  final String secondaryColor;
  final String size;
  final String imageUrl;

  ProductVariantImage({
    required this.primaryColor,
    required this.secondaryColor,
    required this.size,
    required this.imageUrl,
  });

  /// Semantic key used for grouping variants by color
  String get colorKey => '$primaryColor.$secondaryColor';

  /// Factory constructor to parse raw string format: color1.color2.size.imageUrl
  factory ProductVariantImage.fromRaw(String raw) {
    print('Getting image link');
    final parts = raw.split('.');
    if (parts.length < 4) {
      throw FormatException("Invalid variant image format: $raw");
    }

    final url = parts.sublist(3).join('.');
    final normalizedUrl = url.startsWith('http') ? url : 'https://$url';
    print(normalizedUrl);

    return ProductVariantImage(
      primaryColor: parts[0],
      secondaryColor: parts[1],
      size: parts[2],
      imageUrl: normalizedUrl,
    );
  }

  @override
  String toString() {
    return 'Variant: $primaryColor/$secondaryColor, Size: $size, URL: $imageUrl';
  }
}
