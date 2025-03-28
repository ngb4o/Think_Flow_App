part of 'widget_imports.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: null,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: null,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: null,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password
          TextFormField(
                controller: null,
                validator: (value) => TValidator.validatePassword(value),
                // obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: TTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                    },
                    // icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                    icon: Icon(Iconsax.eye),
                  ),
                ),
              ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Terms & Conditions Checkbox
          const TTermsAndConditionCheckbox(),

          const SizedBox(height: TSizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
