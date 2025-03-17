class ProductVariationModel {
  final String id;
  String sku;
  String image;
  String? description;
  double price;
  double salePrice;
  int stock;
  Map<String, String> attributeValues; // Default to empty map

  ProductVariationModel({
    required this.id,
    this.sku = '',
    this.image = '',
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
    required this.attributeValues,
  });

  // Create Empty func for clean code
  static ProductVariationModel empty() => ProductVariationModel(
        id: '',
        attributeValues: {},
      );

  // Json Format
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Image': image,
      'Description': description,
      'Price': price,
      'SalePrice': salePrice,
      'Stock': stock,
      'AttributeValues': attributeValues,
    };
  }

  // Map Json oriented document snapshot from Firebase to Model
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductVariationModel.empty();

    return ProductVariationModel(
      id: data['Id'] ?? '', // Default to empty string if null
      price: double.tryParse((data['Price'] ?? 0.0).toString()) ??
          0.0, // Safely parse price
      sku: data['SKU'] ?? '', // Default to empty string if null
      stock: data['Stock'] ?? 0, // Default to 0 if null
      salePrice: double.tryParse((data['SalePrice'] ?? 0.0).toString()) ??
          0.0, // Safely parse salePrice
      image: data['Image'] ?? '', // Default to empty string if null
      attributeValues: data['AttributeValues'] != null
          ? Map<String, String>.from(data['AttributeValues'])
          : {}, // Default to empty map if null
    );
  }
}
