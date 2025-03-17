import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:flutter_application_1/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:flutter_application_1/features/shop/controllers/product_controller.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../all_products/all_products.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_category.dart';
import 'widgets/home_promo_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      backgroundColor: HelperFunctions.isDarkMode(context)
          ? AppColors.dark
          : AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  //  AppBar
                  const HomeAppBar(),
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),

                  // SearchBar
                  SearchContainer(
                    text: 'Search in store'.tr,
                    showBorder: false,
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),

                  // Categories
                  const Padding(
                    padding: EdgeInsets.only(left: AppSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Heading
                        Sectionheading(
                          showActionButton: false,
                          title: 'Popular Categories',
                          textColor: AppColors.white,
                        ),
                        SizedBox(
                          height: AppSizes.spaceBtwItems,
                        ),

                        // Categories
                        HomeCategories(),
                      ],
                    ),
                  ),
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
                  // Promo Slider
                  const PromoSilder(),

                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),

                  // Popular Products
                  Sectionheading(
                    title: 'Popular Products'.tr,
                    showActionButton: true,
                    onPressed: () => Get.to(() => const AllProducts(
                          title: 'Popular Products',
                        )),
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const VerticalProductShimmer();
                    }
                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'No products found!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return GridLayout(
                        itemCount: controller.featuredProducts.length,
                        itemBuilder: (context, index) => ProductCardVertical(
                              product: controller.featuredProducts[index],
                            ));
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: CircularContainer(
                padding: 0,
                backgroundColor: AppColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: CircularContainer(
                padding: 0,
                backgroundColor: AppColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
