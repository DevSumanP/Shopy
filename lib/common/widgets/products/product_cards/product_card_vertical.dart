import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/images/rounded_images.dart';
import 'package:flutter_application_1/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:flutter_application_1/common/widgets/texts/product_price_text.dart';
import 'package:flutter_application_1/common/widgets/texts/product_title_text.dart';
import 'package:flutter_application_1/features/shop/controllers/cart_controller.dart';
import 'package:flutter_application_1/features/shop/controllers/product_controller.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/features/shop/screens/product_details/product_detail.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/enum.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../favourite_icon/favourite_icon.dart';

class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePrice(product.price, product.salePrice);
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetail(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGrey.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 50,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
          color: dark ? AppColors.darkerGrey : AppColors.white,
        ),
        child: Column(
          children: [
            // Thumbnail, wishlist Button, Discount tag
            RoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(AppSizes.sm),
              backgroundColor: dark ? AppColors.dark : AppColors.white,
              child: Stack(
                children: [
                  // Thumbnail Image
                  Center(
                    child: RoundedImage(
                      height: 150,
                      width: 150,
                      isNetworkImage: true,
                      imageUrl: product.thumbnail,
                      applyImageRadius: true,
                    ),
                  ),

                  // Sale Tag
                  Positioned(
                    top: 12,
                    child: RoundedContainer(
                        radius: AppSizes.sm,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm, vertical: AppSizes.xs),
                        backgroundColor: AppColors.secondary.withOpacity(0.8),
                        child: Text(
                          '$salePercentage%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: AppColors.black),
                        )),
                  ),

                  // Favourite Icon Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FavouriteIcon(
                      productId: product.id,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),

            // Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text
                    ProductTitleText(
                      title: product.title,
                      smallSize: true,
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems / 2),
                    BrandTitleWithVerifiedIcon(title: product.brand.name),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (product.productType ==
                              ProductType.single.toString() &&
                          product.salePrice > 0)
                        Padding(
                            padding: const EdgeInsets.only(left: AppSizes.sm),
                            child: Text(
                              '\$${product.price.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                      decoration: TextDecoration.lineThrough),
                            )),

                      // Price
                      Padding(
                        padding: const EdgeInsets.only(left: AppSizes.sm),
                        child: ProductPriceText(
                          price: controller.getProductPrice(product),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add to Cart Button
                ProductCardAddToCartButton(
                  product: product,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProductCardAddToCartButton extends StatelessWidget {
  const ProductCardAddToCartButton({
    super.key,
    required this.product,
  });

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return GestureDetector(
      onTap: () {
        final cartItem = cartController.convertToCartItem(product, 1);
        cartController.addOneToCart(cartItem);
      },
      child: Obx(() {
        final productQuantityInCart =
            cartController.getProductQuantityInCart(product.id);
        return Container(
          decoration: BoxDecoration(
              color: productQuantityInCart > 0
                  ? AppColors.primary
                  : AppColors.dark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.cardRadiusMd),
                bottomRight: Radius.circular(AppSizes.productImageRadius),
              )),
          child: SizedBox(
              width: AppSizes.iconLg * 1.2,
              height: AppSizes.iconLg * 1.2,
              child: Center(
                  child: productQuantityInCart > 0
                      ? Text(
                          productQuantityInCart.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: AppColors.white),
                        )
                      : const Icon(Iconsax.add, color: AppColors.white))),
        );
      }),
    );
  }
}
