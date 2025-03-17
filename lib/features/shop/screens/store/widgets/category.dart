import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/features/shop/models/category_model.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import '../../../../../common/widgets/brands/brand_showcase.dart';
import '../../../../../utils/constants/images.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    // final controller = Get.find<ProductController>();
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
              padding: const EdgeInsets.all(AppSizes.defaultSpace),
              child: Column(
                children: [
                  // Brands
                  BrandShowCase(
                    isDarkMode: isDarkMode,
                    images: const [
                      Images.productImage1,
                      Images.productImage2,
                      Images.productImage3
                    ],
                  ),
                  BrandShowCase(
                    isDarkMode: isDarkMode,
                    images: const [
                      Images.productImage1,
                      Images.productImage2,
                      Images.productImage3
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwItems,
                  ),

                  //  Products
                  const Sectionheading(
                    title: 'You might like',
                    showActionButton: true,
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwItems,
                  ),

                  //
                  GridLayout(
                      itemCount: 4,
                      itemBuilder: (context, index) =>
                           ProductCardVertical(product: ProductModel.empty(),)),
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  )
                ],
              )),
        ]);
  }
}
