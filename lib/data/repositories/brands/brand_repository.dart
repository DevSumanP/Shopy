import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/brand_model.dart';
import 'package:flutter_application_1/utils/exceptions/format_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all brands
  Future<List<BrandModel>> getAllBrands() async {
    try {
      // Fetch data from Firestore
      final QuerySnapshot snapshot =
          await _firestore.collection('Brands').get();

      // Map the response to BrandModel
      final list = snapshot.docs
          .map((doc) => BrandModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return list;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching brands: $e';
    }
  }
}
