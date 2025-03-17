import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/authentication/controllers/forgot_password/forget_password_controller.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/validators/validators.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            //  Headings
            Text(
              'Forget Password',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: AppSizes.spaceBtwItems,
            ),
            Text(
              "Don't worry sometimes peope can forget, enter your email and we will send you a password reset link.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(
              height: AppSizes.spaceBtwSections * 2,
            ),

            //  Text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: (value) => Validators.validateEmail(value),
                decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ),
            const SizedBox(
              height: AppSizes.spaceBtwSections,
            ),

            //  Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller
                      .sendPasswordResetEmail(controller.email.text.trim()),
                  child: const Text('Submit')),
            )
          ],
        ),
      ),
    );
  }
}
