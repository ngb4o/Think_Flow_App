part of 'profile_imports.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Delete account warning
    void deleteAccountWarningPopup() {
      Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Delete Account',
        middleText: 'Are you sure you want to delete your account permanently ? '
            'This action is not reversible and all of your data will be removed permanently',
        confirm: ElevatedButton(
          // onPressed: () => controller.deleteUserAccount(),
          onPressed: () {

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
          child: const Padding(padding: EdgeInsets.symmetric(horizontal: TSizes.lg), child: Text('Delete')),
        ),
        cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Cancel'),
        ),
      );
    }

    return Scaffold(
      appBar: const TAppbar(
        title: Text('Profile'),
        showBackArrow: true,
      ),

      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Obx(() {
                    //   final networkImage = controller.user.value.profilePicture;
                    //   final image = networkImage.isNotEmpty ? networkImage : TImages.user;
                    //   return controller.imageUploading.value
                    //       ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                    //       : TCircularImage(
                    //     image: image,
                    //     width: 80,
                    //     height: 80,
                    //     isNetworkImage: networkImage.isNotEmpty,
                    //   );
                    // }),
                    TCircularImage(image: TImages.user, height: 80, width: 80),
                    TextButton(
                      // onPressed: () => controller.uploadUserProfilePicture(),
                      onPressed: () {

                      },
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              // Details
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Heading Profile Infor
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              TProfileMenu(
                  title: 'Name',
                  value: '${widget.userModel.data?.lastName} ${widget.userModel.data?.firstName}',
                  // onTap: () => Get.to(() => const UpdateNameScreen()),),
                  onTap: () {

                  }
              ),
              TProfileMenu(title: 'Username', value: '${widget.userModel.data?.firstName}', onTap: () {}),

              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Heading Personal Infor
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              TProfileMenu(
                  title: 'User ID', value: '${widget.userModel.data?.id}', onTap: () {}, icon: Iconsax.copy),
              TProfileMenu(title: 'E-mail', value: '${widget.userModel.data?.email}', onTap: () {}),
              TProfileMenu(title: 'Phone', value: '${widget.userModel.data?.phone}', onTap: () {}),
              TProfileMenu(title: 'Gender', value: '${widget.userModel.data?.gender}', onTap: () {}),
              TProfileMenu(title: 'Status', value: '${widget.userModel.data?.status}', onTap: () {}),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: deleteAccountWarningPopup,
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
