import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class CategoryRepositoryWithMongoDb extends GetxController {
  static CategoryRepositoryWithMongoDb get instance => Get.find();

  // API URL (adjust to your actual backend URL)
  final String apiUrl = 'http://192.168.1.91:5000/api/categories';

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Make a GET request to fetch banners
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Map the response to BannerModel
        final list = data.map((json) => CategoryModel.fromJson(json)).toList();
        return list;
      } else {
        throw 'Failed to load banners. Status code: ${response.statusCode}';
      }
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching banners: $e';
    }
  }

  // Get Sub categories

  // Upload Categories to the cloud firestore
}
