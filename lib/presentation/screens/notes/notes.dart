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

  final TextEditingController _titleController = TextEditingController();
  final bool dark = false; // You can change this based on your theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {},
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
                  controller: _titleController,
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
                              child: Container(
                                width: double.infinity,
                                child: Text(tab, textAlign: TextAlign.center,),
                              ),
                            )
                          ).toList(),
                          tabAlignment: TabAlignment.fill,
                          indicatorColor: TColors.primary,
                          labelColor: dark ? TColors.white : TColors.primary,
                          unselectedLabelColor: TColors.darkerGrey,
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
  }
}
