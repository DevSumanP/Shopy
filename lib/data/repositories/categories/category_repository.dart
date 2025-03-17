import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/category_model.dart';
import 'package:get/get.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  // Get all categories from Firestore
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Reference to the categories collection
      final CollectionReference categoriesCollection =
          FirebaseFirestore.instance.collection('Categories');

      // Fetch the categories
      final QuerySnapshot snapshot = await categoriesCollection.get();

      // Map the response to CategoryModel
      final list = snapshot.docs
          .map((doc) =>
              CategoryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return list;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching categories: $e';
    }
  }

  // Get Sub categories

  // Upload Categories to the cloud firestore
}
