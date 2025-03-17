import 'package:flutter_application_1/data/repositories/banners/banner_repository.dart';
import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';
import '../models/banner_model.dart';

class BannerController extends GetxController {
  // Variables
  final carouselCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final _bannerRepository = BannerRepository();

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  // Update Page Navigation Dot
  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }

  // Fetch banner
  Future<void> fetchBanners() async {
    try {
      // Show Loader while loading categories
      isLoading.value = false;

      // Fetch categories from data source (Firebase, API, etc.)
      final banners = await _bannerRepository.getBanners();

      // Assign banners
      this.banners.assignAll(banners);
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
