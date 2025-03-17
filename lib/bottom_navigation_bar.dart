import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/personalization/screens/settings/settings.dart';
import 'package:flutter_application_1/features/shop/screens/home/home.dart';
import 'package:flutter_application_1/features/shop/screens/store/store.dart';
import 'package:flutter_application_1/features/shop/screens/wishlist/wishlist.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'utils/helpers/helper_functions.dart';

class BottomNavMenu extends StatelessWidget {
  const BottomNavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavMenuController());
    final darkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: darkMode ? AppColors.black : AppColors.white,
          indicatorColor: darkMode
              ? AppColors.white.withOpacity(0.1)
              : AppColors.black.withOpacity(0.1),
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectIndex.value,
          onDestinationSelected: (index) =>
              controller.selectIndex.value = index,
          destinations: [
            NavigationDestination(
                icon: const Icon(Iconsax.home), label: 'Home'.tr),
            NavigationDestination(
                icon: const Icon(Iconsax.shop), label: 'Store'.tr),
            NavigationDestination(
                icon: const Icon(Iconsax.heart), label: 'Wishlist'.tr),
            NavigationDestination(
                icon: const Icon(Iconsax.user), label: 'Profile'.tr),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectIndex.value]),
    );
  }
}

class BottomNavMenuController extends GetxController {
  final RxInt selectIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    const StoreScreen(),
    const FavouriteScreen(),
    const SettingsScreen()
  ];
}
