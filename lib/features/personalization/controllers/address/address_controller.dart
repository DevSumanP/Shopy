import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/data/repositories/address/address_repository.dart';
import 'package:flutter_application_1/data/services/network_manager.dart';
import 'package:flutter_application_1/features/personalization/models/adddress/address_model.dart';
import 'package:flutter_application_1/features/personalization/screens/address/add_new_address.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:flutter_application_1/utils/popups/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popups/loaders.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../../utils/constants/sizes.dart';
import '../../screens/address/widgets/single_address.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addresskey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  // Fetch all user specific addresses
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();

      selectedAddress.value = addresses.firstWhere(
        (element) => element.selectedAddress,
        orElse: () => AddressModel.empty(),
      );

      return addresses;
    } catch (e) {
      Loaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      Get.defaultDialog(
        title: '',
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const CircularProgressIndicator(),
      );
      // Clear the "selected" field
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
            selectedAddress.value.id, false);
      }

      // Assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // Set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(
          selectedAddress.value.id, true);

      Get.back();
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error in selection', message: e.toString());
    }
  }

  Future addNewAddress() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Storing Address...', Images.loaderAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!addresskey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Create a new address model
      final address = AddressModel(
        id: '', // Generate or assign an ID
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        postalCode: postalCode.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
        dateTime: DateTime.now(),
      );

      // Save the new address
      final id = await addressRepository.addAddress(address);

      // Update Selected Address State
      address.id = id;
      await selectAddress(address);

      // Stop Loading
      FullScreenLoader.stopLoading();

      // Refresh address
      refreshData.toggle();

      // Clear the form
      name.clear();
      phoneNumber.clear();
      street.clear();
      postalCode.clear();
      city.clear();
      state.clear();
      country.clear();
      addresskey.currentState?.reset();

      // Show success message
      Loaders.successSnackBar(
          title: 'Success', message: 'Address added successfully');

      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Address not found', message: e.toString());
    }
  }

  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Sectionheading(
                title: 'Select Address',
                showActionButton: false,
              ),
              const SizedBox(
                height: AppSizes.spaceBtwSections,
              ),
              FutureBuilder(
                key: Key(refreshData.value.toString()),
                future: getAllUserAddresses(),
                builder: (context, snapshot) {
                  // Shimmer loader while waiting for data
                  const loader = ShimmerEffect(
                    width: double.infinity,
                    height: 100,
                  );

                  // Handle the waiting state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loader;
                  }

                  // Handle errors
                  if (snapshot.hasError) {
                    debugPrint('Error loading addresses: ${snapshot.error}');
                    return const Center(
                      child: Text(
                        'Something went wrong! Please try again later.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  // Handle empty data or no favorites
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    debugPrint('Address is empty: ${snapshot.data}');
                    return const Center(
                      child: Text('Address is empty.'),
                    );
                  }

                  final addresses = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap:
                        true, // Prevent ListView from taking infinite height
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable internal scrolling
                    itemCount: addresses.length,
                    itemBuilder: (context, index) => SingleAddress(
                      address: addresses[index],
                      onTap: () async {
                        await selectAddress(addresses[index]);
                        Get.back();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: AppSizes.spaceBtwSections / 2,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const AddNewAddressScreen()),
                  child: const Text('Add new address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
