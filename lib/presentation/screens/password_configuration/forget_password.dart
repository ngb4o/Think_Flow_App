part of 'password_configuration_imports.dart';

@RoutePage()
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  _forgotPasswordSummit(String email) {
    if (formKey.currentState!.validate()) {
      context.read<PasswordConfigurationBloc>().add(
          PasswordConfigurationClickButtonForgotPasswordEvent(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordConfigurationBloc, PasswordConfigurationState>(
      listenWhen: (previous, current) =>
          current is PasswordConfigurationActionState,
      buildWhen: (previous, current) =>
          current is! PasswordConfigurationActionState,
      listener: (context, state) {
        if (state is PasswordConfigurationForgotPasswordSuccessState) {
          AutoRouter.of(context).push(ResetPasswordScreenRoute(email: emailController.text));
          TLoaders.successSnackBar(context,
              title: 'Success',
              message: 'Please check your email to get the OTP code.');
        } else if (state
            is PasswordConfigurationForgotPasswordErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          ),
          body: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headings
                Text(
                  TTexts.forgetPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  TTexts.forgetPasswordSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Textfield
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) => TValidator.validateEmail(value),
                    decoration: const InputDecoration(
                      labelText: TTexts.email,
                      prefixIcon: Icon(Iconsax.direct_right),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                //Submit Button
                if (state is PasswordConfigurationForgotPasswordLoadingState)
                  TLoadingSpinkit.loadingButton
                else 
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _forgotPasswordSummit(emailController.text.trim()),
                      child: const Text(TTexts.submit),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
