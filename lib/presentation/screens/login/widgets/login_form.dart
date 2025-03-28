part of 'widget_imports.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: null,
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Password
            TextFormField(
                controller: null,
                validator: (value) => TValidator.validateEmptyText('Password', value),
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
                // obscureText: null,
              ),

            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {
                        },
                      ),
                      const Text(TTexts.rememberMe),
                    ],
                  ),

                // Forget Password
                TextButton(
                  onPressed: () {
                    AutoRouter.of(context).push(ForgetPasswordScreenRoute());
                  },
                  child: const Text(TTexts.forgetPassword, style: TextStyle(color: TColors.primary)),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                child: const Text(TTexts.signIn),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  AutoRouter.of(context).push(SignUpScreenRoute());
                },
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
