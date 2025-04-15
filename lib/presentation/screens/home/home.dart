part of 'home_imports.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    context.read<HomeBloc>().add(HomeLoadMoreDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigationToCreateTextNotePageActionState) {
          AutoRouter.of(context).push(TextNotesPageRoute());
        } else if (state is HomeNavigationToCreateAudioNotePageActionState) {
          AutoRouter.of(context).push(AudioNotesPageRoute());
        } else if (state is HomeErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              // Appbar
              THomeAppBar(),

              // Body
              Expanded(
                child: state is HomeLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : state is HomeSuccessState
                        ? RefreshIndicator(
                            onRefresh: () async {
                              context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
                            },
                            child: ListView.builder(
                              controller: null,
                              padding: EdgeInsets.all(TSizes.defaultSpace),
                              itemCount: state.noteModel.data.length,
                              itemBuilder: (context, index) {
                                final note = state.noteModel.data[index];
                                return Padding(
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
                                                Icon(Iconsax.trash),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              'You don\'t have any notes yet',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            icon: Iconsax.note_add5,
            activeIcon: Iconsax.close_square,
            iconTheme: IconThemeData(color: TColors.primary, size: 35),
            backgroundColor: Colors.transparent,
            elevation: 0,
            spacing: 10,
            spaceBetweenChildren: 10,
            children: [
              SpeedDialChild(
                child: Icon(Iconsax.microphone),
                label: 'Audio Notes',
                onTap: () {
                  context.read<HomeBloc>().add(HomeClickButtonNavigationToCreateRecordNotePageEvent());
                },
              ),
              SpeedDialChild(
                child: Icon(Iconsax.note_21),
                label: 'Text Notes',
                onTap: () {
                  context.read<HomeBloc>().add(HomeClickButtonNavigationToCreateTextNotePageEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
