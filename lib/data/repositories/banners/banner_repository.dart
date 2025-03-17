import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/banner_model.dart';
import 'package:flutter_application_1/utils/exceptions/format_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  // Get all banners from Firebase Firestore
  Future<List<BannerModel>> getBanners() async {
    try {
      // Fetch banners from Firestore
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Banners')
          .where('active', isEqualTo: true)
          .get();

      // Map the response to BannerModel
      final list = snapshot.docs
          .map(
              (doc) => BannerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return list;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching banners: $e';
    }
  }
}
