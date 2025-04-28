part of 'widget_imports.dart';

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

  _shareLinkNoteToEmail() {
    if (formKey.currentState!.validate()) {
      context.read<HomeBloc>().add(
            HomeClickButtonShareLinkNoteToEmailEvent(
              noteId: widget.noteId,
              email: emailController.text.trim(),
              permission: _selectedAccess,
            ),
          );
    }
  }

  _createLinkNote() {
    context.read<HomeBloc>().add(
          HomeClickButtonCreateLinkNoteEvent(
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
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeShareLinkNoteToEmailSuccessActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
          Navigator.pop(context);
          TLoaders.successSnackBar(context, title: 'Share link successfully');
        } else if (state is HomeShareLinkNoteToEmailErrorActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
          Navigator.pop(context);
          TLoaders.errorSnackBar(context, title: 'Share link failed', message: state.message);
        } else if (state is HomeCreateLinkNoteSuccessActionState) {
          _copyLinkToClipboard(state.link!);
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        } else if (state is HomeCreateLinkNoteErrorActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
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
                      padding: const EdgeInsets.all(16),
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
                            SizedBox(height: TSizes.sm),
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
                            SizedBox(height: TSizes.sm),
                            Text('Shared with anyone', style: Theme.of(context).textTheme.bodyLarge),
                            SizedBox(height: TSizes.sm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (state is HomeCreateLinkNoteLoadingState)
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
                                if (state is HomeShareLinkNoteToEmailLoadingState)
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
