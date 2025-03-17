import 'dart:convert';

import 'package:flutter_application_1/data/repositories/product/product_repository_mongodb.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/utils/local_storage/storage_utility.dart';
import 'package:flutter_application_1/utils/popups/loaders.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  // variables
  final favourites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavourites();
  }

  // method to initialize favourites by reading drom storage
  Future<void> initFavourites() async {
    final json = LocalStorage.instance().readData('favourites');
    if (json != null) {
      final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
      favourites.assignAll(
          storedFavourites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favourites[productId] ?? false;
  }

  void toggleFavouriteProduct(String productId) {
    if (!favourites.containsKey(productId)) {
      favourites[productId] = true;
      saveFavouritesToStorage();
      Loaders.customToast(message: 'Product has been added to the WishList.');
    } else {
      LocalStorage.instance().removeData(productId);
      favourites.remove(productId);
      saveFavouritesToStorage();
      favourites.refresh();
    }
  }

  void saveFavouritesToStorage() {
    final encodedFavourites = json.encode(favourites);
    LocalStorage.instance().saveData('favourites', encodedFavourites);
  }

  Future<List<ProductModel>> favouriteProducts() async {
    if (favourites.isEmpty) {
      return [];
    }
    return await ProductRepository.instance
        .getFavouriteProducts(favourites.keys.toList());
  }
}
