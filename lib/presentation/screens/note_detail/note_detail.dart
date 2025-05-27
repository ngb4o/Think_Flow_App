part of 'note_detail_imports.dart';

@RoutePage()
class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.title,
    required this.createAt,
    required this.permission,
    required this.ownerName,
  });

  final String noteId;
  final String title;
  final String createAt;
  final String permission;
  final String ownerName;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final tabs = ["Text", "Audio", "Summary Note", "Mindmap Note"];

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
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    context.read<NoteDetailBloc>().add(
        NoteDetailClickButtonUpdateTitleEvent(noteId: noteId, title: title));
  }

  void shareNoteBottomSheet(String noteId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeShareNote(noteId: noteId),
    );
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
          TLoaders.errorSnackBar(context,
              title: 'Update failed', message: state.message);
        } else if (state is NotesUpdateNotifyUpdateActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
          context.read<NoteShareBloc>().add(NoteShareInitialFetchDataEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: TAppbar(
            showBackArrow: true,
            actions: [
              if (state is NoteUpdateDetailLoadingState)
                TLoadingSpinkit.loadingButton
              else if (widget.permission != 'read') ...[
                if (widget.permission != 'write')
                  IconButton(
                    onPressed: () => shareNoteBottomSheet(widget.noteId),
                    icon: Icon(Iconsax.share),
                  ),
                IconButton(
                  onPressed: () =>
                      _updateNote(widget.noteId, _titleController.text.trim()),
                  icon: Icon(Iconsax.tick_square4),
                ),
              ],
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
                    style:
                        Theme.of(context).textTheme.headlineMedium!.copyWith(),
                    cursorColor: Theme.of(context).primaryColor,
                    backgroundCursorColor: Colors.grey,
                    onChanged: (value) {
                      if (widget.permission != 'read') {
                        _titleController.text = value;
                      }
                    },
                    readOnly: widget.permission == 'read',
                  ),
                  SizedBox(height: TSizes.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.permission == 'read' ||
                      widget.permission == 'write')
                    Column(
                      children: [
                        SizedBox(height: TSizes.sm),
                        Row(
                          children: [
                            Text('Share by ',
                                style: Theme.of(context).textTheme.bodySmall),
                            SizedBox(width: TSizes.xs),
                            TCircularImage(
                                image: TImages.user, height: 30, width: 30),
                            Text(' ${widget.ownerName}',
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TTabBar(
                    tabs: [
                      Tab(
                          icon: Icon(
                            Iconsax.document_text,
                            size: 20,
                          ),
                          text: tabs[0]),
                      Tab(
                          icon: Icon(Iconsax.microphone, size: 20),
                          text: tabs[1]),
                      Tab(icon: Icon(Iconsax.flash, size: 20), text: tabs[2]),
                      Tab(
                          icon: Icon(Iconsax.hierarchy_3, size: 20),
                          text: tabs[3]),
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
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        KeepAliveWrapper(
                            child: TextDetailTab(
                                noteId: widget.noteId,
                                permission: widget.permission,
                                titleNote: widget.title)),
                        KeepAliveWrapper(
                            child: AudioDetailTab(
                                noteId: widget.noteId,
                                permission: widget.permission)),
                        KeepAliveWrapper(
                            child: SummaryDetailTab(
                                noteId: widget.noteId,
                                permission: widget.permission)),
                        KeepAliveWrapper(
                            child: MindmapDetailTab(
                          noteId: widget.noteId,
                          permission: widget.permission,
                        )),
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
