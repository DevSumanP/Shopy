import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/appbar/tabbar.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:flutter_application_1/common/widgets/shimmer/brand_shimmer.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/features/shop/controllers/brand_controller.dart';
import 'package:flutter_application_1/features/shop/controllers/category_controller.dart';
import 'package:flutter_application_1/features/shop/screens/brand/all_brands.dart';
import 'package:flutter_application_1/features/shop/screens/brand/brand_products.dart';
import 'package:flutter_application_1/features/shop/screens/store/widgets/category.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/brands/brand_card.dart';
import '../../../../utils/helpers/helper_functions.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
            backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
            appBar: Appbar(
              title: Text(
                'Store',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              actions: [
                CartCounterIcon(
                  iconColor: isDarkMode ? AppColors.white : AppColors.black,
                )
              ],
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrollable) {
                return [
                  SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      floating: true,
                      backgroundColor:
                          isDarkMode ? AppColors.black : AppColors.white,
                      expandedHeight: 440,
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.all(
                          AppSizes.defaultSpace,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Searchbar

                            const SearchContainer(
                              text: 'Search in store',
                              showBackground: false,
                              showBorder: true,
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwSections,
                            ),

                            // Featured Brands
                            Sectionheading(
                              title: 'Featured Brands',
                              showActionButton: true,
                              onPressed: () =>
                                  Get.to(() => const AllBrandsScreen()),
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwItems / 1.5,
                            ),
                            Obx(() {
                              if (brandController.isLoading.value) {
                                return const BrandShimmer();
                              }
                              if (brandController.featuredBrands.isEmpty) {
                                return Center(
                                    child: Text(
                                  'No Data Found!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(color: Colors.white),
                                ));
                              }
                              return GridLayout(
                                itemCount:
                                    brandController.featuredBrands.length,
                                mainAxisExtent: 80,
                                itemBuilder: (context, index) {
                                  final brand =
                                      brandController.featuredBrands[index];
                                  return BrandCard(
                                    showBorder: true,
                                    brand: brand,
                                    onTap: () => Get.to(
                                        () => BrandProducts(brand: brand)),
                                  );
                                },
                              );
                            })
                          ],
                        ),
                      ),

                      //  Tabs
                      bottom: CustomTabBar(
                          tabs: categories
                              .map(
                                  (category) => Tab(child: Text(category.name)))
                              .toList()))
                ];
              },
              body: TabBarView(
                  children: categories
                      .map((category) => CategoryTab(category: category))
                      .toList()),
            )));
  }
}
