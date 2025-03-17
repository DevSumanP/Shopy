import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottom_navigation_bar.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/icons/circular_icon.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:flutter_application_1/features/shop/controllers/favourite_controller.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/loaders/animation_loader.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/shimmer/vertical_product_shimmer.dart';
import '../../../../utils/constants/images.dart';
import '../../models/product_model.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());
    return Scaffold(
        appBar: Appbar(
          title: Text(
            'Wishlist',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            CircularIcon(
              icon: Iconsax.add,
              onPressed: () => Get.to(const BottomNavMenu()),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: Column(
              children: [
                Obx(
                  () => FutureBuilder<List<ProductModel>>(
                    future: controller.favouriteProducts(),
                    builder: (context, snapshot) {
                      // Shimmer loader while waiting for data
                      final loader = VerticalProductShimmer(
                          itemCount: controller.favourites.length);

                      // Handle the waiting state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loader;
                      }

                      // Handle errors
                      if (snapshot.hasError) {
                        debugPrint(
                            'Error loading favourite products: ${snapshot.error}');
                        return const Center(
                          child: Text(
                            'Something went wrong! Please try again later.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      // Handle empty data or no favorites
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        debugPrint('Wishlist is empty: ${snapshot.data}');
                        return AnimationLoaderWidget(
                          text: 'Whoops! Your wishlist is empty...',
                          animation: Images.pencilAnimation,
                          showAction: true,
                          actionText: 'Let\'s add some',
                          onActionPressed: () =>
                              Get.to(() => const BottomNavMenu()),
                        );
                      }

                      // Data is available
                      final products = snapshot.data!;

                      return GridLayout(
                        itemCount: products.length,
                        itemBuilder: (_, index) => ProductCardVertical(
                          product: products[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
