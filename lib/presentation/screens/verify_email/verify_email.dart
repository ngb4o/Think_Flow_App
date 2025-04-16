part of 'verify_email_imports.dart';

@RoutePage()
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  final TextEditingController otpController5 = TextEditingController();
  final TextEditingController otpController6 = TextEditingController();

  String getCompleteOTP() {
    return '${otpController1.text}${otpController2.text}${otpController3.text}${otpController4.text}${otpController5.text}${otpController6.text}';
  }

  _verifyEmail() {
    context.read<VerifyEmailBloc>().add(
          VerifyEmailButtonClickEvent(
            email: widget.email.toString(),
            otp: getCompleteOTP(),
          ),
        );
  }

  _resendEmailVerify() {
    context.read<VerifyEmailBloc>().add(
          ResendVerifyEmailButtonClickEvent(
            email: widget.email.toString(),
          ),
        );
  }

  _navigationToLoginPage() {
    context.read<VerifyEmailBloc>().add(
          VerifyEmailButtonClickNavigationToLoginPageEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
      listenWhen: (previous, current) => current is VerifyEmailActionState,
      buildWhen: (previous, current) => current is! VerifyEmailActionState,
      listener: (context, state) {
        if (state is VerifyEmailErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Verify email failed', message: state.message);
        } else if (state is ResendVerifyEmailSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Resend verify successfully', message: state.dataModel.data);
        } else if (state is ResendVerifyEmailErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Resend verify email failed', message: state.message);
        } else if (state is VerifyEmailNavigationToSuccessPageActionState) {
          AutoRouter.of(context).push(
            SuccessScreenRoute(
              animation: Assets.animations72462CheckRegister,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () {
                TLoaders.successSnackBar(context,
                    title: 'Verify email successfully', message: 'Please login to continue');
                AutoRouter.of(context).pushAndPopUntil(
                  LoginScreenRoute(),
                  predicate: (_) => false,
                );
              },
            ),
          );
        } else if (state is VerifyEmailNavigationToLoginPageActionState) {
          AutoRouter.of(context).pushAndPopUntil(LoginScreenRoute(), predicate: (_) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () => _navigationToLoginPage(),
                icon: const Icon(
                  CupertinoIcons.clear,
                  color: TColors.primary,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  // Image
                  Image(
                    image: const AssetImage(TImages.deliveredEmailIllustration),
                    width: THelperFunctions.screenWidth(context) * 0.6,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Title & Subtitle
                  Text(
                    TTexts.confirmEmail,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    widget.email ?? '',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    TTexts.confirmEmailSubTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // OTP TextField
                  Form(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 68,
                            child: TextFormField(
                                controller: otpController1,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 68,
                            child: TextFormField(
                                controller: otpController2,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 68,
                            child: TextFormField(
                                controller: otpController3,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 68,
                            child: TextFormField(
                                controller: otpController4,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 68,
                            child: TextFormField(
                                controller: otpController5,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 68,
                            child: TextFormField(
                                controller: otpController6,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    // When last field is filled, verify email
                                    final otp = getCompleteOTP();
                                    if (otp.length == 6 && widget.email != null) {
                                      _verifyEmail();
                                    }
                                  }
                                },
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  if (state is ResendVerifyEmailLoadingState || state is VerifyEmailLoadingState)
                    LoadingSpinkit.loadingButton
                  else
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _resendEmailVerify(),
                        child: Text(TTexts.resendEmail, style: TextStyle(color: TColors.primary)),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
