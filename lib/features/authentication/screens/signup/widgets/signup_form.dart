import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/authentication/controllers/signup/signup_controller.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/validators/validators.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: controller.signUpFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller.firstName,
                validator: (value) =>
                    Validators.validateText('First Name', value),
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              )),
              const SizedBox(width: AppSizes.spaceBtwInputFields),
              Expanded(
                  child: TextFormField(
                controller: controller.lastName,
                validator: (value) =>
                    Validators.validateText('Last Name', value),
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              )),
            ],
          ),

          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            expands: false,
            controller: controller.userName,
            validator: (value) => Validators.validateText('User Name', value),
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => Validators.validateEmail(value),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => Validators.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Password
          Obx(
            () => TextFormField(
              obscureText: controller.hidePassword.value,
              controller: controller.password,
              validator: (value) => Validators.validatePassword(value),
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Iconsax.direct),
                  suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye))),
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwSections),

          // Terms & COnditions
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Obx(
                  () => Checkbox(
                    value: controller.privacyPolicy.value,
                    onChanged: (value) => controller.privacyPolicy.value =
                        !controller.privacyPolicy.value,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceBtwInputFields),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'I agree to the ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: 'Privacy Policy',
                    style: Theme.of(context).textTheme.bodyMedium?.apply(
                          color: dark ? AppColors.white : AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              dark ? AppColors.white : AppColors.primary,
                        )),
                TextSpan(
                    text: ' and ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: 'Terms of use',
                  style: Theme.of(context).textTheme.bodyMedium?.apply(
                        color: dark ? AppColors.white : AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            dark ? AppColors.white : AppColors.primary,
                      ),
                ),
              ]))
            ],
          ),
          const SizedBox(height: AppSizes.spaceBtwSections),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signUp(),
              child: const Text('Create Account'),
            ),
          )
        ],
      ),
    );
  }
}
