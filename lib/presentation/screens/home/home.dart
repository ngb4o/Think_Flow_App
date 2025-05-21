part of 'home_imports.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<HomeBloc>().add(HomeLoadMoreDataEvent());
      }
    });
  }

  void deleteNoteWarningPopup(String noteId) {
    TWarningPopup.show(
      context: context,
      title: 'Delete Note',
      message: 'Are you sure you want to delete this note? This action cannot be undone.',
      onConfirm: () {
        context.read<HomeBloc>().add(HomeClickButtonDeleteNoteEvent(noteId: noteId));
      },
    );
  }

  void shareNoteBottomSheet(String noteId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeShareNote(noteId: noteId),
    );
  }

  void _archiveNote(String noteId) {
    context.read<HomeBloc>().add(HomeClickButtonArchiveNoteEvent(noteId: noteId));
  }

  void _showNoteActionsBottomSheet(String noteId) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? TColors.dark : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Iconsax.archive_23, size: 25),
              title: Text('Archive Note', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _archiveNote(noteId);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Iconsax.share, size: 25),
              title: Text('Share Note', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                shareNoteBottomSheet(noteId);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigationToCreateNotesPageActionState) {
          AutoRouter.of(context).push(NotesPageRoute());
        } else if (state is HomeNavigationToShareNotePageActionState) {
          AutoRouter.of(context).push(NoteShareScreenRoute());
        } else if (state is HomeErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        } else if (state is HomeNavigationToNoteDetailPageActionState) {
          AutoRouter.of(context).push(NoteDetailScreenRoute(
            noteId: state.noteId,
            title: state.title,
            createAt: state.createAt,
            permission: state.permission,
            ownerName: state.ownerName,
          ));
        } else if (state is HomeDeleteNoteSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Delete successfully');
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        } else if (state is HomeDeleteNoteErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Delete failed', message: state.message);
        } else if (state is HomeNavigationToArchivedPageActionState) {
          AutoRouter.of(context).push(NoteArchivedScreenRoute());
        } else if (state is HomeArchiveNoteSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Note archived successfully');
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        } else if(state is HomeArchiveNoteErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Note archived failed', message: state.message);
        } else if (state is HomeNavigationToNotificationPageState) {
          AutoRouter.of(context).push(NotificationScreenRoute());
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return Scaffold(
              body: Column(
                children: [
                  THomeAppBar(),
                  const Expanded(
                    child: Center(child: LoadingSpinkit.loadingPage),
                  ),
                ],
              ),
            );
          case HomeSuccessState:
            final notes = state as HomeSuccessState;
            return Scaffold(
              body: Column(
                children: [
                  // Appbar
                  THomeAppBar(
                    actionButtonOnPressed: () => context.read<HomeBloc>().add(HomeClickButtonNavigationToNotificationPageEvent()),
                  ),

                  // Body
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
                      },
                      child: notes.noteModel.data.isEmpty
                          ? Center(
                              child: TEmpty(
                                subTitle: 'Create your first note to get started',
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(TSizes.defaultSpace),
                              itemCount: notes.noteModel.data.length,
                              itemBuilder: (context, index) {
                                final note = notes.noteModel.data[index];
                                return GestureDetector(
                                  onTap: () => context.read<HomeBloc>().add(HomeClickNavigationToNoteDetailPageEvent(
                                        noteId: note.id,
                                        title: note.title,
                                        createAt: note.createdAt,
                                        permission: note.permission,
                                        ownerName: '${note.user.firstName} ${note.user.lastName}'
                                      )),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: TColors.grey, width: 1),
                                        color: TColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: TColors.primary.withOpacity(0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      ),
                                      padding: EdgeInsets.all(TSizes.spaceBtwItems),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  note.title,
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              if (state is HomeDeleteNoteLoadingState)
                                                LoadingSpinkit.loadingButton
                                              else
                                                GestureDetector(
                                                  onTap: () {
                                                    deleteNoteWarningPopup(note.id);
                                                  },
                                                  child: Icon(Iconsax.trash, size: 20,),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: TSizes.lg),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                note.createdAt,
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                              GestureDetector(
                                                onTap: () => _showNoteActionsBottomSheet(note.id),
                                                child: Icon(Iconsax.more, size: 25),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                child: SpeedDial(
                  icon: Iconsax.note_favorite5,
                  activeIcon: Iconsax.close_square,
                  iconTheme: IconThemeData(size: 40),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  spacing: 5,
                  spaceBetweenChildren: 5,
                  children: [
                    SpeedDialChild(
                      child: Icon(Iconsax.archive_23),
                      label: 'Archived',
                      onTap: () {
                        context.read<HomeBloc>().add(HomeClickButtonNavigationToArchivedPageEvent());
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Iconsax.share),
                      label: 'Share with me',
                      onTap: () {
                        context.read<HomeBloc>().add(HomeClickButtonNavigationToShareNotePageEvent());
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Iconsax.note_21),
                      label: 'Notes',
                      onTap: () {
                        context.read<HomeBloc>().add(HomeClickButtonNavigationToCreateNotesPageEvent());
                      },
                    ),
                  ],
                ),
              ),
            );
          case HomeErrorState:
            return Scaffold(
              body: Column(
                children: [
                  THomeAppBar(),
                  Expanded(
                    child: Center(
                      child: TEmpty(
                        subTitle: 'Create your first note to get started',
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
