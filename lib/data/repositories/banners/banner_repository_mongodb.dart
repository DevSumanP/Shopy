import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/banner_model.dart';
import 'package:flutter_application_1/utils/exceptions/format_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BannerRepositoryWithMongoDb extends GetxController {
  static BannerRepositoryWithMongoDb get instance => Get.find();

  // API URL (adjust to your actual backend URL)
  final String apiUrl = 'http://192.168.1.91:5000/api/banners';

  // Get all banners from API
  Future<List<BannerModel>> getBanners() async {
    try {
      // Make a GET request to fetch banners
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Map the response to BannerModel
        final list = data.map((json) => BannerModel.fromJson(json)).toList();
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
}
