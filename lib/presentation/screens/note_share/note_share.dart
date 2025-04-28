part of 'note_share_imports.dart';

@RoutePage()
class NoteShareScreen extends StatefulWidget {
  const NoteShareScreen({super.key});

  @override
  State<NoteShareScreen> createState() => _NoteShareScreenState();
}

class _NoteShareScreenState extends State<NoteShareScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<NoteShareBloc>().add(NoteShareInitialFetchDataEvent());
    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // void _onScroll() {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
  //       context.read<NoteShareBloc>().add(NoteShareLoadMoreDataEvent());
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteShareBloc, NoteShareState>(
      listenWhen: (previous, current) => current is NoteShareActionState,
      buildWhen: (previous, current) => current is! NoteShareActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case NoteShareLoadingState:
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                title: Text('Share With Me'),
                centerTitle: true,
              ),
              body: const Center(child: LoadingSpinkit.loadingPage),
            );
          case NoteShareSuccessState:
            final notes = state as NoteShareSuccessState;
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                title: Text('Share With Me'),
                centerTitle: true,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<NoteShareBloc>().add(NoteShareInitialFetchDataEvent());
                },
                child: notes.noteModel.data.isEmpty
                    ? Center(
                        child: TEmpty(
                          subTitle: 'No shared notes yet',
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
                                        if(note.permission == 'read') 
                                          Icon(Iconsax.book_1)
                                        else
                                          Icon(Iconsax.magicpen)
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
            );
          case NoteShareErrorState:
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                title: Text('Share With Me'),
                centerTitle: true,
              ),
              body: Center(
                child: TEmpty(
                  subTitle: 'No shared notes yet',
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
