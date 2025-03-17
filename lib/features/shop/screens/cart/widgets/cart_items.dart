import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/shop/controllers/cart_controller.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class CartItems extends StatelessWidget {
  const CartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(
          height: AppSizes.spaceBtwSections,
        ),
        itemCount: cartController.cartItems.length,
        itemBuilder: (_, index) {
          return Obx(() {
            final item = cartController.cartItems[index];
            return Column(
              children: [
                CartItem(
                  cartItem: item,
                ),
                if (showAddRemoveButtons)
                  const SizedBox(height: AppSizes.spaceBtwItems),
                if (showAddRemoveButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          ProductQuantityWithAddRemoveButton(
                            add: () => cartController.addOneToCart(item),
                            remove: () =>
                                cartController.removeOneFromCart(item),
                            quantity: item.quantity,
                          ),
                        ],
                      ),
                      ProductPriceText(
                          price:
                              (item.price * item.quantity).toStringAsFixed(1)),
                    ],
                  )
              ],
            );
          });
        },
      ),
    );
  }
}
