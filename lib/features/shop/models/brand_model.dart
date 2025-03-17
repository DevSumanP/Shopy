import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String id;
  final String name;
  final String image;
  final bool? isFeatured;
  final int? productsCount;

  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured,
    this.productsCount,
  });

  // Empty Helper Function
  static BrandModel empty() => BrandModel(
        id: '',
        image: '',
        name: '',
      );

  // Convert model to JSON structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': image,
      'productsCount': productsCount,
      'isFeatured': isFeatured,
    };
  }

  // Factory method to create a BrandModel from JSON
  factory BrandModel.fromJson(Map<String, dynamic> document) {
    if (document.isEmpty) {
      return BrandModel.empty();
    }
    return BrandModel(
      id: document['id'] ?? '',
      name: document['name'] ?? '',
      image: document['imageUrl'] ?? '',
      productsCount: document['productsCount'] ?? 0,
      isFeatured: document['isFeatured'] ?? false,
    );
  }

  // Factory method to create a BrandModel from Firestore snapshot
  factory BrandModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || data.isEmpty) {
      return BrandModel.empty();
    }

    return BrandModel(
      id: snapshot.id, // Use Firestore document ID as the ID
      name: data['name'] ?? '',
      image: data['imageUrl'] ?? '',
      productsCount: data['productsCount'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
    );
  }
}
