part of 'notes_imports.dart';

@RoutePage()
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final tabs = ["Text", "Audio"];

  int currentTabIndex = 0;

  final TextEditingController titleController = TextEditingController();

  _createNote(String title) {
    context.read<NotesBloc>().add(NotesClickButtonCreateEvent(title: title));
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool dark = THelperFunctions.isDarkMode(context);

    return BlocConsumer<NotesBloc, NotesState>(
      listenWhen: (previous, current) => current is NotesActionState,
      buildWhen: (previous, current) => current is !NotesActionState,
      listener: (context, state) {
        if(state is NotesCreateSuccessActionSate) {
          TLoaders.successSnackBar(context, title: 'Create success',);
        }else if (state is NotesCreateTextSuccessActionState){
          Navigator.pop(context);
        }else  if(state is NotesCreateErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Create error', message: state.message);
        }else if(state is NotesCreateTextErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Create error', message: state.message);
        } else if(state is NotesNotifyHomeUpdateActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: TAppbar(
            showBackArrow: true,
            title: Text('Notes'),
            actions: [
              if(state is NotesCreateLoadingState)
                LoadingSpinkit.loadingButton
              else
                IconButton(
                  onPressed: () => _createNote(titleController.text.trim()),
                  icon: Icon(Iconsax.tick_square4),
                ),
            ],
          ),
          body: DefaultTabController(
            length: tabs.length,
            initialIndex: currentTabIndex,
            child: SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: TTexts.title,
                      ),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        children: [
                          Divider(),
                          // Tabs bar
                          Material(
                            color: dark ? TColors.black : TColors.white,
                            child: TabBar(
                              tabs: tabs.map((tab) =>
                                  Tab(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(tab, textAlign: TextAlign.center,),
                                    ),
                                  )
                              ).toList(),
                              tabAlignment: TabAlignment.fill,
                              indicatorColor: TColors.primary,
                              labelColor: dark ? TColors.white : TColors.primary,
                              unselectedLabelColor: TColors.darkerGrey,
                              dividerColor: Colors.transparent,
                              onTap: (value) {
                                setState(() {
                                  currentTabIndex = value;
                                });
                              },
                            ),
                          ),


                          Expanded(
                            child: TabBarView(
                              children: [
                                TextNotesPage(),
                                AudioNotesPage(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
