import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String imageUrl = '';
  final String targetScreen;
  final bool active;

  BannerModel({
    required this.targetScreen,
    required this.active,
    required this.imageUrl,
  });

  // Empty Helper Function
  static BannerModel empty() =>
      BannerModel(targetScreen: '', active: false, imageUrl: '');

  // Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'image': imageUrl,
      'targetScreen': targetScreen,
      'active': active,
    };
  }

  // Convert Json structure to model
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      targetScreen: json['targetScreen'] ?? '',
      active: json['active'] ?? false,
      imageUrl: json['image'] ?? '',
    );
  }

  // Map Json oriented document snapshot from firebase to userModel
  factory BannerModel.fromSnapshot(DocumentSnapshot document) {
    if (document.data() != null) {
      final data = document.data() as Map<String, dynamic>?;

      return BannerModel(
          targetScreen: data!['targetScreen'] ?? '',
          active: data['active'] ?? false,
          imageUrl: data['image'] ?? '');
    } else {
      return BannerModel.empty();
    }
  }
}
