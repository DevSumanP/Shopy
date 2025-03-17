import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, String>? selectedVariation;

  CartItemModel({
    required this.productId,
    this.title = '',
    this.price = 0.0,
    required this.quantity,
    this.variationId = '',
    this.image,
    this.brandName,
    this.selectedVariation,
  });

  factory CartItemModel.empty() {
    return CartItemModel(
      productId: '',
      title: '',
      price: 0.0,
      quantity: 0,
      variationId: '',
      image: null,
      brandName: null,
      selectedVariation: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'brandName': brandName,
      'selectedVariation': selectedVariation,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      title: json['title'] ?? '',
      price: json['price'] ?? 0.0,
      quantity: json['quantity'],
      variationId: json['variationId'] ?? '',
      image: json['image'],
      brandName: json['brandName'],
      selectedVariation:
          Map<String, String>.from(json['selectedVariation'] ?? {}),
    );
  }

  factory CartItemModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CartItemModel.fromJson(data);
  }
}
