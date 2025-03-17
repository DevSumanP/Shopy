import 'package:cloud_firestore/cloud_firestore.dart';
import 'brand_model.dart';
import 'product_attribute_model.dart';
import 'product_variation_model.dart';

class ProductModel {
  final String id;
  final String sku;
  final String title;
  final int stock;
  final bool isFeatured;
  final double price;
  final double salePrice;
  final String thumbnail;
  final String? description;
  final String productType;
  final String? categoryId;
  final List<String> images;
  final List<ProductAttributeModel> productAttributes;
  final List<ProductVariationModel> productVariations;
  final BrandModel brand;

  ProductModel({
    required this.id,
    required this.sku,
    required this.title,
    required this.stock,
    required this.isFeatured,
    required this.price,
    required this.salePrice,
    required this.thumbnail,
    this.description,
    required this.productType,
    this.categoryId,
    required this.images,
    required this.productAttributes,
    required this.productVariations,
    required this.brand,
  });

  /// Factory constructor for creating a ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      title: json['title'] ?? '',
      stock: json['stock'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      salePrice: json['salePrice'] != null
          ? double.tryParse(json['salePrice'].toString()) ?? 0.0
          : 0.0,
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'],
      productType: json['productType'] ?? '',
      categoryId: json['categoryId'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      productAttributes: json['productAttributes'] != null
          ? (json['productAttributes'] as List<dynamic>)
              .map((e) => ProductAttributeModel.fromJson(e))
              .toList()
          : [],
      productVariations: json['productVariations'] != null
          ? (json['productVariations'] as List<dynamic>)
              .map((e) => ProductVariationModel.fromJson(e))
              .toList()
          : [],
      brand: json['brand'] != null
          ? BrandModel.fromSnapshot(json['brand'][
              0]) // Handle the list of brands (assuming the response contains one brand in the array)
          : BrandModel.empty(),
    );
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {}; // Ensure non-null data map
    return ProductModel(
      id: document.id,
      sku: data['sku'] ?? '',
      title: data['title'] ?? 'No title',
      stock: data['stock'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
      price: double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
      salePrice: double.tryParse(data['salePrice']?.toString() ?? '0.0') ?? 0.0,
      thumbnail: data['thumbnail'],
      categoryId: data['categoryId'] ?? '',
      description: data['description'] ?? '',
      productType: data['productType'] ?? 'single',
      brand: data['brand'] != null
          ? BrandModel.fromJson(data['brand'])
          : BrandModel.empty(),
      images: data['images'] != null ? List<String>.from(data['images']) : [],
      productAttributes: (data['productAttributes'] as List<dynamic>?)
              ?.map((e) => ProductAttributeModel.fromJson(e))
              .toList() ??
          [],
      productVariations: (data['productVariations'] as List<dynamic>?)
              ?.map((e) => ProductVariationModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Factory constructor for creating a ProductModel from a QueryDocumentSnapshot
  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ProductModel(
      id: document.id,
      sku: data['sku'],
      title: data['title'],
      stock: data['stock'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
      price: double.parse((data['price'] ?? 0.0).toString()),
      salePrice: double.parse((data['salePrice'] ?? 0.0).toString()),
      thumbnail: data['thumbnail'] ?? '',
      categoryId: data['categoryId'] ?? '',
      description: data['description'] ?? '',
      productType: data['productType'] ?? '',
      brand: BrandModel.fromJson(data['brand']),
      images: data['images'] != null ? List<String>.from(data['images']) : [],
      productAttributes: (data['productAttributes'] as List<dynamic>)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList(),
      productVariations: (data['productVariations'] as List<dynamic>)
          .map((e) => ProductVariationModel.fromJson(e))
          .toList(),
    );
  }

  /// Factory constructor for creating an empty ProductModel
  factory ProductModel.empty() {
    return ProductModel(
      id: '0',
      sku: '0',
      title: 'Empty',
      stock: 0,
      isFeatured: false,
      price: 1.0,
      salePrice: 1.0,
      thumbnail: '',
      description: '',
      productType: 'single',
      categoryId: '1',
      images: [],
      productAttributes: [],
      productVariations: [],
      brand: BrandModel.empty(),
    );
  }
}
