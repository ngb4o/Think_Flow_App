part of 'profile_imports.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(ProfileInitialFetchDataEvent());
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      context.read<ProfileBloc>().add(ProfileUpdateAvatarEvent(imageFile: File(pickedFile.path)));
    }
  }

  // Delete account warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account permanently ? '
          'This action is not reversible and all of your data will be removed permanently',
      confirm: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is ProfileUpdateAvatarErrorState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        } else if (state is ProfileUpdateAvatarSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Success', message: 'Avatar updated successfully');
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return Scaffold(body: Center(child: LoadingSpinkit.loadingPage));
        } else if (state is ProfileSuccessState) {
          final networkImage = state.userModel.data?.avatar?.url;
          final image = networkImage?.isNotEmpty == true ? networkImage! : TImages.user;

          return Scaffold(
            appBar: TAppbar(
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
                          if (state.isAvatarLoading)
                            const CircularProgressIndicator()
                          else
                            TCircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage?.isNotEmpty == true,
                            ),
                          TextButton(
                            onPressed: _pickImage,
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
                    const TSectionHeading(
                        title: 'Profile Information', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    TProfileMenu(
                      title: 'Name',
                      value:
                          '${state.userModel.data?.firstName} ${state.userModel.data?.lastName}',
                      onTap: () {},
                    ),
                    TProfileMenu(
                      title: 'Username',
                      value: '${state.userModel.data?.firstName}',
                      onTap: () {},
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Heading Personal Infor
                    const TSectionHeading(
                        title: 'Profile Information', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    TProfileMenu(
                      title: 'User ID',
                      value: '${state.userModel.data?.id}',
                      onTap: () {},
                      icon: Iconsax.copy,
                    ),
                    TProfileMenu(
                      title: 'E-mail',
                      value: '${state.userModel.data?.email}',
                      onTap: () {},
                    ),
                    TProfileMenu(
                      title: 'Phone',
                      value: '${state.userModel.data?.phone}',
                      onTap: () {},
                    ),
                    TProfileMenu(
                      title: 'Gender',
                      value: '${state.userModel.data?.gender}',
                      onTap: () {},
                    ),
                    TProfileMenu(
                      title: 'Status',
                      value: '${state.userModel.data?.status}',
                      onTap: () {},
                    ),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    Center(
                      child: TextButton(
                        onPressed: deleteAccountWarningPopup,
                        child: const Text('Close Account',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProfileErrorState) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        }
        return const SizedBox();
      },
    );
  }
}
