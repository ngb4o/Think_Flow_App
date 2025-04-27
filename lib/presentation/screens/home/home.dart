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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigationToCreateNotesPageActionState) {
          AutoRouter.of(context).push(NotesPageRoute());
        } else if (state is HomeNavigationToShareNotePageActionState) {
        } else if (state is HomeErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        } else if (state is HomeNavigationToNoteDetailPageActionState) {
          AutoRouter.of(context).push(NoteDetailScreenRoute(
            noteId: state.noteId,
            title: state.title,
            createAt: state.createAt,
          ));
        } else if (state is HomeDeleteNoteSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Delete successfully');
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        } else if (state is HomeDeleteNoteErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Delete failed', message: state.message);
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
                    child: Center(child: CircularProgressIndicator()),
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
                  THomeAppBar(),

                  // Body
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
                      },
                      child: ListView.builder(
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
                                )),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: TColors.grey, width: 2),
                                ),
                                padding: EdgeInsets.all(TSizes.spaceBtwItems),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: TSizes.spaceBtwItems),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          note.createdAt,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Iconsax.archive_tick),
                                            SizedBox(width: TSizes.spaceBtwItems),
                                            if (state is HomeDeleteNoteLoadingState)
                                              LoadingSpinkit.loadingButton
                                            else
                                              GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<HomeBloc>()
                                                      .add(HomeClickButtonDeleteNoteEvent(noteId: note.id));
                                                },
                                                child: Icon(Iconsax.trash),
                                              ),
                                          ],
                                        )
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
              floatingActionButton: SpeedDial(
                icon: Iconsax.note_15,
                activeIcon: Iconsax.close_square,
                iconTheme: IconThemeData(color: TColors.primary, size: 40),
                backgroundColor: Colors.transparent,
                elevation: 0,
                spacing: 10,
                spaceBetweenChildren: 10,
                children: [
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
            );
          case HomeErrorState:
            return Scaffold(
              body: Column(
                children: [
                  THomeAppBar(),
                  Expanded(
                    child: Center(
                      child: Text(
                        'You don\'t have any notes yet',
                        style: Theme.of(context).textTheme.bodyLarge,
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
