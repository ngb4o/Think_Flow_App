part of 'password_configuration_imports.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool hidePassword = true;

  _resendOtp() {
    context.read<PasswordConfigurationBloc>().add(
        PasswordConfigurationClickButtonForgotPasswordEvent(
            email: widget.email));
  }

  _resetPassword(String newPassword, String otp) {
    context.read<PasswordConfigurationBloc>().add(
        PasswordConfigurationClickButtonResetPasswordEvent(
            email: widget.email, newPassword: newPassword, otp: otp));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordConfigurationBloc, PasswordConfigurationState>(
      listenWhen: (previous, current) =>
          current is PasswordConfigurationActionState,
      buildWhen: (previous, current) =>
          current is! PasswordConfigurationActionState,
      listener: (context, state) {
        if(state is PasswordConfigurationResetPasswordSuccessState) {
          AutoRouter.of(context).replace(LoginScreenRoute());
          TLoaders.successSnackBar(context, title: 'Success', message: 'Your password has been reset successfully.'); 
        } else if(state is PasswordConfigurationResetPasswordErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        } else if(state is PasswordConfigurationForgotPasswordErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  AutoRouter.of(context).replace(LoginScreenRoute());
                },
                icon: const Icon(CupertinoIcons.clear, color: TColors.primary),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: TSizes.defaultSpace,
                  right: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  // Image
                  Image(
                    image: const AssetImage(TImages.deliveredEmailIllustration),
                    width: THelperFunctions.screenWidth(context) * 0.7,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Email & Title & Subtitle
                  Text(widget.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Text(
                    TTexts.changeYourPasswordSubTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  Form(
                    child: Column(
                      children: [
                        // Password
                        TextFormField(
                          controller: passwordController,
                          validator: (value) =>
                              TValidator.validateEmptyText('Password', value),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Iconsax.password_check),
                            labelText: TTexts.newPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(hidePassword
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye),
                            ),
                          ),
                          obscureText: hidePassword,
                        ),
                        SizedBox(height: TSizes.spaceBtwInputFields),

                        // OTP
                        TextFormField(
                          controller: otpController,
                          validator: (value) =>
                              TValidator.validateEmptyText('Password', value),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Iconsax.barcode),
                            labelText: TTexts.otp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Buttons
                  if (state is PasswordConfigurationResetPasswordLoadingState)
                    LoadingSpinkit.loadingButton
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _resetPassword(
                            passwordController.text.trim(),
                            otpController.text.trim()),
                        child: const Text(TTexts.submit),
                      ),
                    ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Resend
                  if (state is PasswordConfigurationForgotPasswordLoadingState)
                    LoadingSpinkit.loadingButton
                  else
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _resendOtp(),
                        child: const Text(
                          TTexts.resendEmail,
                          style: TextStyle(color: TColors.primary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
