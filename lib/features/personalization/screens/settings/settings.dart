import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/list_tiles.dart/settings_menu_tiles.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_application_1/features/personalization/controllers/language/language_controller.dart';
import 'package:flutter_application_1/features/personalization/controllers/search/switch_controller.dart';
import 'package:flutter_application_1/features/personalization/screens/address/address.dart';
import 'package:flutter_application_1/features/shop/screens/cart/cart.dart';
import 'package:flutter_application_1/features/shop/screens/coupons/coupons.dart';
import 'package:flutter_application_1/features/shop/screens/home/home.dart';
import 'package:flutter_application_1/features/shop/screens/order/order.dart';
import 'package:flutter_application_1/localization/localization_service.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/list_tiles.dart/profile_tile.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../location/screens/map/map.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());
    final switchController = Get.put(SwitchController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  Appbar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: AppColors.white),
                    ),
                  ),

                  // User Profile Card
                  const ProfileTile(),
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(AppSizes.defaultSpace),
              child: Column(
                children: [
                  // Account Settings
                  const Sectionheading(title: 'Account Settings'),
                  const SizedBox(
                    height: AppSizes.spaceBtwItems,
                  ),

                  SettingsMenuTiles(
                      onTap: () {
                        Get.to(() => const UserAddressScreen());
                      },
                      icon: Iconsax.safe_home,
                      title: 'My Addresses',
                      subTitle: 'Set shopping delivery address'),
                  SettingsMenuTiles(
                      onTap: () {
                        Get.to(() => const CartScreen());
                      },
                      icon: Iconsax.shopping_cart,
                      title: 'My Cart',
                      subTitle: 'Add, remove products and move to checkout'),
                  SettingsMenuTiles(
                      onTap: () {
                        Get.to(() => const OrderScreen());
                      },
                      icon: Iconsax.bag_tick,
                      title: 'My Orders',
                      subTitle: 'In-progress and Completed orders'),
                  const SettingsMenuTiles(
                      icon: Iconsax.bank,
                      title: 'Bank Account',
                      subTitle: 'Withdraw balamnce to registered bank account'),
                  SettingsMenuTiles(
                      onTap: () {
                        Get.to(() => const Coupons());
                      },
                      icon: Iconsax.discount_shape,
                      title: 'My Coupons',
                      subTitle: 'List of all the discounted coupons'),
                  const SettingsMenuTiles(
                      icon: Iconsax.notification,
                      title: 'Notifications',
                      subTitle: 'Set any kind of notification message'),
                  SettingsMenuTiles(
                      onTap: () {
                        Get.to(() => const MapScreen());
                      },
                      icon: Iconsax.security_card,
                      title: 'Account Privacy',
                      subTitle: 'Manage data usage and connected accounts'),

                  // App Settings
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),
                  const Sectionheading(title: 'App Settings'),
                  const SizedBox(
                    height: AppSizes.spaceBtwItems,
                  ),

                  SettingsMenuTiles(
                    icon: Iconsax.location,
                    title: 'Language Change',
                    subTitle: 'Set your desired language',
                    trailing: DropdownButton<String>(
                      elevation: 0,
                      value: LocalizationService.getCurrentLocal()
                          .languageCode, // Get current language code
                      onChanged: (String? newValue) async {
                        if (newValue != null) {
                          // Update the language using the controller's method
                          await languageController.updateLanguage(newValue);
                        }
                      },
                      items: <String>['en', 'np']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              value == 'en' ? Images.en : Images.np,
                              height: 20,
                              width: 30,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SettingsMenuTiles(
                    icon: Iconsax.security_user,
                    title: 'Safe Mode',
                    subTitle: 'Search results is safe for all ages',
                    trailing: Obx(
                      () => Switch(
                        value: switchController.isSafeMode.value,
                        onChanged: (bool value) {
                          switchController.isSafeMode.value = value;
                        },
                      ),
                    ),
                  ),
                  SettingsMenuTiles(
                    icon: Iconsax.image,
                    title: 'HD Image Quality',
                    subTitle: 'Set image quality to high definition',
                    trailing: Obx(
                      () => Switch(
                        value: switchController.isHDImage.value,
                        onChanged: (bool value) {
                          switchController.isHDImage.value = value;
                        },
                      ),
                    ),
                  ),

                  // Logout button
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          AuthenticationRepository.instance.logOut();
                        },
                        child: const Text('Logout')),
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwSections * 1.5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
