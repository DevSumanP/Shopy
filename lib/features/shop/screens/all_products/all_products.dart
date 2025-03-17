import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/sortable/sortable.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/all_products_controller.dart';
import '../../models/product_model.dart';

class AllProducts extends StatelessWidget {
  const AllProducts(
      {super.key, required this.title, this.futureMethod, this.query});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    Get.put(AllProductsController());
    return Scaffold(
      appBar: Appbar(
        title: Text(title),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .where('isFeatured', isEqualTo: true)
                  .get(),
              builder: (context, snapshot) {
                // Check the state of the FutureBuilder snapshot
                const loader = VerticalProductShimmer();

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loader;
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Data Found!'),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong!'),
                  );
                }

                final products = snapshot.data!.docs
                    .map((doc) => ProductModel.fromSnapshot(doc))
                    .toList();
                return SortableProducts(
                  products: products,
                );
              }),
        ),
      ),
    );
  }
}
