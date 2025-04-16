part of 'widget_imports.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool rememberMe = true;
  bool hidePassword = true;

  _login() {
    if (formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginButtonClickEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => current is LoginActionSate || current is LoginSuccessState,
      buildWhen: (previous, current) => current is! LoginActionSate,
      listener: (context, state) {
        if (state is LoginSuccessState) {
          rememberMe ? Utils.setIsLoggedIn(true) : Utils.setIsLoggedIn(false);
        } else if (state is LoginErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Login failed', message: state.message);
        } else if (state is LoginNavigationToSignupPageActionState) {
          AutoRouter.of(context).push(SignUpScreenRoute());
        } else if (state is LoginNavigationToForgetPasswordPageActionState) {
          AutoRouter.of(context).push(ForgetPasswordScreenRoute());
        } else if (state is LoginSuccessActionState) {
          AutoRouter.of(context).pushAndPopUntil(
            const NavigationMenuRoute(),
            predicate: (_) => false,
          );
        } else if(state is LoginNavigationToVerifyEmailPage) {
          AutoRouter.of(context).push(VerifyEmailScreenRoute(email: state.email));
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
            child: Column(
              children: [
                // Email
                TextFormField(
                  controller: emailController,
                  validator: (value) => TValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email,
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Password
                TextFormField(
                  controller: passwordController,
                  validator: (value) => TValidator.validateEmptyText('Password', value),
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
                  obscureText: hidePassword,
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
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        const Text(TTexts.rememberMe),
                      ],
                    ),

                    // Forget Password
                    TextButton(
                      onPressed: () => context.read<LoginBloc>().add(LoginClickButtonNavigationToForgetPasswordPageEvent()),
                      child: const Text(TTexts.forgetPassword, style: TextStyle(color: TColors.primary)),
                    ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                // Sign In Button
                if (state is LoginLoadingState)
                  LoadingSpinkit.loadingButton
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text(TTexts.signIn),
                    ),
                  ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.read<LoginBloc>().add(LoginClickButtonNavigationToSignupPageEvent()),
                    child: const Text(TTexts.createAccount),
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
