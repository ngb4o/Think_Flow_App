part of '../widget_imports.dart';

class HomeShareNote extends StatefulWidget {
  const HomeShareNote({
    super.key,
    required this.noteId,
  });

  final String noteId;

  @override
  State<HomeShareNote> createState() => _HomeShareNoteState();
}

class _HomeShareNoteState extends State<HomeShareNote> {
  String _selectedAccess = 'read';
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _copiedLink;

  @override
  void initState() {
    super.initState();
    context.read<HomeShareNoteBloc>().add(HomeShareNoteInitialFetchDataMemberEvent(noteId: widget.noteId));
  }

  _shareLinkNoteToEmail() {
    if (formKey.currentState!.validate()) {
      context.read<HomeShareNoteBloc>().add(
            HomeShareNoteClickButtonShareLinkNoteToEmailEvent(
              noteId: widget.noteId,
              email: emailController.text.trim(),
              permission: _selectedAccess,
            ),
          );
    }
  }

  _createLinkNote() {
    context.read<HomeShareNoteBloc>().add(
          HomeShareNoteClickButtonCreateLinkNoteEvent(
            noteId: widget.noteId,
            permission: _selectedAccess,
          ),
        );
  }

  _copyLinkToClipboard(String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    setState(() {
      _copiedLink = link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeShareNoteBloc, HomeShareNoteState>(
      listenWhen: (previous, current) => current is HomeShareNoteActionState,
      buildWhen: (previous, current) => current is! HomeShareNoteActionState,
      listener: (context, state) {
        if (state is HomeShareNoteShareLinkNoteToEmailSuccessActionState) {
          Navigator.pop(context);
          TLoaders.successSnackBar(context, title: 'Share note successfully');
        } else if (state is HomeShareNoteShareLinkNoteToEmailErrorActionState) {
          Navigator.pop(context);
          TLoaders.errorSnackBar(context, title: 'Share note failed', message: state.message);
        } else if (state is HomeShareNoteCreateLinkNoteSuccessActionState) {
          _copyLinkToClipboard(state.link!);
        } else if (state is HomeShareNoteUpdatePermissionMemberSuccessActionState) {
          context.read<HomeShareNoteBloc>().add(HomeShareNoteInitialFetchDataMemberEvent(noteId: widget.noteId));
          TLoaders.successSnackBar(context, title: 'Permission updated successfully');
        } else if (state is HomeShareNoteUpdatePermissionMemberErrorState) {
          TLoaders.errorSnackBar(context, title: 'Update permission failed', message: state.message);
        }
      },
      builder: (context, state) {
        final isDarkMode = THelperFunctions.isDarkMode(context);

        return Form(
          key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: isDarkMode ? TColors.dark : TColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Padding(
              padding: EdgeInsets.all(TSizes.sm),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Share This Note',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(left: TSizes.md, right: TSizes.md, top: TSizes.xs),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Share note via e-mail', style: Theme.of(context).textTheme.bodyLarge),
                            SizedBox(height: TSizes.sm),
                            TextFormField(
                              controller: emailController,
                              validator: (value) => TValidator.validateEmail(value),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Iconsax.password_check),
                                labelText: TTexts.email,
                              ),
                            ),
                            SizedBox(height: TSizes.md),
                            Text('Access Permissions', style: Theme.of(context).textTheme.bodyLarge),
                            SizedBox(height: TSizes.sm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('View only'),
                                    value: 'read',
                                    groupValue: _selectedAccess,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAccess = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Can edit'),
                                    value: 'write',
                                    groupValue: _selectedAccess,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAccess = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder<HomeShareNoteBloc, HomeShareNoteState>(
                              buildWhen: (previous, current) => current is HomeShareNoteMemberSuccessState,
                              builder: (context, state) {
                                if (state is HomeShareNoteMemberSuccessState && state.members?.data != null) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Collaborators', style: Theme.of(context).textTheme.bodyLarge),
                                      SizedBox(height: TSizes.sm),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.members!.data!.length,
                                        itemBuilder: (context, index) {
                                          final member = state.members!.data![index];
                                          if (member.permission == 'all') return const SizedBox();
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: TCircularImage(image: TImages.user, height: 40, width: 40),
                                            title: Text('${member.firstName} ${member.lastName}',
                                                style: Theme.of(context).textTheme.bodyMedium),
                                            subtitle: Text(
                                              '${member.email}',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Container(
                                              decoration: BoxDecoration(
                                                color: TColors.primary,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: DropdownButton<String>(
                                                  padding: EdgeInsets.zero,
                                                  value: member.permission,
                                                  iconSize: 22,
                                                  iconEnabledColor: TColors.white,
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: TColors.white),
                                                  isDense: true,
                                                  alignment: AlignmentDirectional.centerEnd,
                                                  dropdownColor: TColors.primary,
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: 'read',
                                                      child: Text('View only'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'write',
                                                      child: Text('Can edit'),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        member.permission = value;
                                                      });
                                                      context.read<HomeShareNoteBloc>().add(
                                                        HomeShareNoteUpdatePermissionMemberEvent(
                                                          noteId: widget.noteId,
                                                          userId: member.id.toString(),
                                                          permission: value,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            Text('Shared with anyone', style: Theme.of(context).textTheme.bodyLarge),
                            SizedBox(height: TSizes.sm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (state is HomeShareNoteCreateLinkNoteLoadingState)
                                  LoadingSpinkit.loadingButton
                                else if (_copiedLink != null)
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      side: WidgetStateProperty.all(BorderSide(color: TColors.primary)),
                                    ),
                                    onPressed: () => _copyLinkToClipboard(_copiedLink!),
                                    child: Row(
                                      children: [
                                        Icon(Iconsax.tick_square),
                                        SizedBox(width: TSizes.md),
                                        Text(
                                          'Copied!',
                                          style:
                                              Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.primary),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      side: WidgetStateProperty.all(BorderSide(color: TColors.primary)),
                                    ),
                                    onPressed: () => _createLinkNote(),
                                    child: Row(
                                      children: [
                                        Icon(Iconsax.copy),
                                        SizedBox(width: TSizes.sm),
                                        Text(
                                          'Copy link',
                                          style:
                                              Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (state is HomeShareNoteShareLinkNoteToEmailLoadingState)
                                  LoadingSpinkit.loadingButton
                                else
                                  ElevatedButton(
                                    onPressed: () => _shareLinkNoteToEmail(),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: TSizes.md),
                                      child: Row(
                                        children: [
                                          Icon(Iconsax.direct_right, color: TColors.white),
                                          SizedBox(width: TSizes.sm),
                                          Text(
                                            'Send',
                                            style:
                                                Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        )
                      ],
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
