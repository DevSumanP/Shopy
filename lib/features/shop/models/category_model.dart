import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  bool isFeatured;
  String parentId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });

  // Empty Helper Function
  static CategoryModel empty() =>
      CategoryModel(id: '', name: '', image: 'image', isFeatured: false);

  // Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'parentId': parentId,
      'isFeatured': isFeatured,
    };
  }

  // Convert Json structure to model
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      parentId: json['parentId'] ?? '',
    );
  }

  // Map Json oriented document snapshot from firebase to userModel
  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();

      return CategoryModel(
          id: document.id,
          name: data!['name'] ?? '',
          image: data['image'] ?? '',
          parentId: data['parentId'] ?? '',
          isFeatured: data['isFeatured'] ?? false);
    } else {
      return CategoryModel.empty();
    }
  }
}
