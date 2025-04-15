part of 'widget_imports.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({super.key});

  @override
  State<TSignupForm> createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool checkPrivacyPolicy = false;

  void _signup() {
    if (formKey.currentState!.validate()) {
      if (!checkPrivacyPolicy) {
        TLoaders.warningSnackBar(
          context,
          title: 'Accept Privacy Policy',
          message: 'In order to create account, '
              'you must have to read and accept the Privacy Policy & Terms Of Use',
        );
        return;
      }
      context.read<SignupBloc>().add(
            SignupButtonClickEvent(
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listenWhen:  (previous, current) => current is SignupActionState,
      buildWhen: (previous, current) => current is !SignupActionState,
      listener: (context, state) {
        if (state is SignupErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Signup Failed', message: state.message);
        } else if (state is SignupNavigationToVerifyEmailScreenActionState) {
          AutoRouter.of(context).push(VerifyEmailScreenRoute(email: emailController.text.trim()));
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              // Name
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      validator: (value) => TValidator.validateEmptyText('First Name', value),
                      decoration: const InputDecoration(
                        labelText: TTexts.firstName,
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      validator: (value) => TValidator.validateEmptyText('Last Name', value),
                      decoration: const InputDecoration(
                        labelText: TTexts.lastName,
                        prefixIcon: Icon(Iconsax.user_add),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Email
              TextFormField(
                controller: emailController,
                validator: (value) => TValidator.validateEmail(value),
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Password
              TextFormField(
                controller: passwordController,
                validator: (value) => TValidator.validatePassword(value),
                obscureText: hidePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: TTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(hidePassword ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Terms & Conditions Checkbox
              TTermsAndConditionCheckbox(
                value: checkPrivacyPolicy,
                onChanged: (value) {
                  setState(() {
                    checkPrivacyPolicy = value;
                  });
                },
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Sign Up Button
              if (state is SignupLoadingState)
                LoadingSpinkit.loadingButton
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signup,
                    child: const Text(TTexts.createAccount),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
