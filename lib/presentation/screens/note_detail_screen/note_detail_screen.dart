part of 'note_detail_screen_imports.dart';

@RoutePage()
class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.title,
  });

  final String noteId;
  final String title;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final tabs = ["Text", "Audio"];

  int currentTabIndex = 0;

  @override
  void initState() {
    context.read<NoteDetailBloc>().add(NoteDetailInitialFetchDataEvent(noteId: widget.noteId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteDetailBloc, NoteDetailState>(
      listenWhen: (previous, current) => current is NoteDetailActionState,
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      listener: (context, state) {
        if (state is NoteDetailErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NoteDetailLoadingState:
            return Scaffold(
              appBar: TAppbar(showBackArrow: true),
              body: const Center(
                child: LoadingSpinkit.loadingPage,
              ),
            );
          case NoteDetailSuccessState:
            final noteDetail = state as NoteDetailSuccessState;
            final textContent = noteDetail.textNoteModel.data?.textContent;

            return Scaffold(
              appBar: TAppbar(showBackArrow: true),
              body: DefaultTabController(
                length: tabs.length,
                initialIndex: currentTabIndex,
                child: Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
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
                                  text: Utils.formatDate(noteDetail.textNoteModel.data?.createdAt),
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
                            TextDetailTab(textContent: textContent),
                            AudioDetailTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          case NoteDetailErrorState:
            return Scaffold(
              appBar: TAppbar(showBackArrow: true),
              body: const Center(
                child: Text('Error loading note'),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
