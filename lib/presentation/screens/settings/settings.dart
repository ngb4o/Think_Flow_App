part of 'settings_imports.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _logout() {
    context.read<SettingsBloc>().add(SettingClickButtonLogoutEvent());
  }

  @override
  void initState() {
    context.read<SettingsBloc>().add(SettingInitialFetchDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) => current is SettingsActionState,
      buildWhen: (previous, current) => current is! SettingsActionState,
      listener: (context, state) {
        if (state is SettingErrorActionState) {
          if (state.message == 'missing access token in cookie') {
            Utils.clearAllSavedData();
            AutoRouter.of(context).replace(LoginScreenRoute());
          }
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        } else if (state is SettingLogoutSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Logout successfully', message: 'You have been logged out. See you again soon');
          AutoRouter.of(context).replace(LoginScreenRoute());
          Utils.clearAllSavedData();
        } else if (state is SettingLogoutErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Logout failed', message: state.message);
        } else if (state is SettingNavigationToProfilePageActionState) {
          AutoRouter.of(context).push(ProfileScreenRoute());
        }
      },
      builder: (context, state) {
        if (state is SettingLoadingState || state is SettingLogoutLoadingState) {
          return TLoadingSpinkit.loadingPage;
        } else if (state is SettingSuccessState) {
          var profileData = state.userModel.data;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  TPrimaryHeaderContainer(
                    child: Column(
                      children: [
                        // Appbar
                        TAppbar(
                          title: Text(
                            'Account',
                            style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),
                          ),
                        ),

                        // User profile Card
                        TUserProfileTile(
                          onPressed: () =>
                              context.read<SettingsBloc>().add(SettingClickButtonNavigationToProfilePageEvent()),
                          fullName: '${profileData?.firstName} ${profileData?.lastName}',
                          email: '${profileData?.email}',
                          avatar: profileData?.avatar?.url ?? TImages.user,
                          isNetworkImage: profileData?.avatar?.url != null,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),

                  // Body
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Account Setting
                        const TSectionHeading(
                          title: 'Account Settings',
                          showActionButton: false,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        const TSettingsMenuTile(
                          title: 'Favorites',
                          subtitle: 'Save your favorite items',
                          icon: Iconsax.heart5,
                        ),

                        const TSettingsMenuTile(
                          title: 'Categories',
                          subtitle: 'Organize and store your summaries',
                          icon: Iconsax.folder_open5,
                        ),

                        const TSettingsMenuTile(
                          title: 'Language',
                          subtitle: 'Select your preferred language',
                          icon: Iconsax.global5,
                        ),

                        // App Settings
                        const SizedBox(height: TSizes.spaceBtwSections),
                        const TSectionHeading(title: 'App Settings', showActionButton: false),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TSettingsMenuTile(
                          title: 'Dark Mode',
                          subtitle: 'Enable to switch to dark mode',
                          trailing: Switch(
                            value: false,
                            onChanged: (value) {},
                          ),
                          icon: Iconsax.moon5,
                        ),
                        const TSettingsMenuTile(
                          title: 'Rate App',
                          subtitle: 'Give us your feedback on the app',
                          icon: Iconsax.medal_star5,
                        ),
                        const TSettingsMenuTile(
                          title: 'Share App',
                          subtitle: 'Share this app with your friends',
                          icon: Iconsax.share5,
                        ),

                        const TSettingsMenuTile(
                          title: 'Invite Friends',
                          subtitle: 'Invite your friends to use this app',
                          icon: Iconsax.user_add,
                        ),

                        // Logout Button
                        const SizedBox(height: TSizes.spaceBtwSections),
                        if (state is SettingLogoutLoadingState)
                          TLoadingSpinkit.loadingButton
                        else
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => _logout(),
                              child: const Text('Logout'),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (state is SettingErrorState) {
          return TErrorWidget(subError: state.message,);
        }
        return SizedBox();
      },
    );
  }
}
