part of 'note_detail_screen_imports.dart';

@RoutePage()
class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.title,
    required this.createAt,
  });

  final String noteId;
  final String title;
  final String createAt;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final tabs = ["Text", "Audio"];

  int currentTabIndex = 0;

  late TextEditingController _titleController;

  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  _updateNote(String noteId, String title) {
    context.read<NoteDetailBloc>().add(NoteClickButtonUpdateEvent(noteId: noteId, title: title));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteDetailBloc, NoteDetailState>(
      listenWhen: (previous, current) => current is NoteDetailActionState,
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      listener: (context, state) {
        if (state is NoteUpdateDetailSuccessActionSate) {
          Navigator.pop(context);
          TLoaders.successSnackBar(context, title: 'Update successfully');
        } else if (state is NoteUpdateDetailErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Update failed', message: state.message);
        } else if (state is NotesUpdateNotifyUpdateActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: TAppbar(
            showBackArrow: true,
            actions: [
              if (state is NoteUpdateDetailLoadingState)
                LoadingSpinkit.loadingButton
              else
                IconButton(
                  onPressed: () => _updateNote(widget.noteId, _titleController.text.trim()),
                  icon: Icon(Iconsax.tick_square4),
                ),
            ],
          ),
          body: DefaultTabController(
            length: tabs.length,
            initialIndex: currentTabIndex,
            child: Padding(
              padding: EdgeInsets.only(
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditableText(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    style: Theme.of(context).textTheme.headlineMedium!,
                    cursorColor: Theme.of(context).primaryColor,
                    backgroundCursorColor: Colors.grey,
                    onChanged: (value) {
                      _titleController.text = value;
                    },
                    onSubmitted: (value) {
                      _updateNote(widget.noteId, value.trim());
                    },
                  ),
                  SizedBox(height: TSizes.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Iconsax.calendar_1,
                        size: 20,
                        color: TColors.darkerGrey,
                      ),
                      SizedBox(width: TSizes.xs),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Date created : ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: widget.createAt,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TTabBar(
                    tabs: [
                      Tab(text: 'Text'),
                      Tab(text: 'Audio'),
                    ],
                    currentIndex: currentTabIndex,
                    onTap: (value) {
                      setState(() {
                        currentTabIndex = value;
                      });
                    },
                    selectedColor: TColors.primary,
                    unselectedColor: Colors.grey.shade200,
                    selectedTextColor: Colors.white,
                    unselectedTextColor: Colors.black,
                    width: MediaQuery.of(context).size.width - (TSizes.defaultSpace * 2),
                    fullWidth: true,
                    paddingBetweenTabs: true,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  Expanded(
                    child: TabBarView(
                      children: [
                        KeepAliveWrapper(child: TextDetailTab(noteId: widget.noteId)),
                        KeepAliveWrapper(child: AudioDetailTab(noteId: widget.noteId)),
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
