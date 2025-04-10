part of 'settings_imports.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {

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
                    onPressed: () {
                    },
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
                    icon: Iconsax.share5
                    ,
                  ),

                  const TSettingsMenuTile(
                    title: 'Invite Friends',
                    subtitle: 'Invite your friends to use this app',
                    icon: Iconsax.user_add,
                  ),

                  // Logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
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
  }
}
