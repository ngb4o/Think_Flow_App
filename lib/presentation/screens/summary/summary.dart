part of 'summary_imports.dart';

@RoutePage()
class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final tabs = ['Record Notes', 'Image Notes', 'Text Notes'];

  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: NestedScrollView(
        // Header
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white,
              expandedHeight: 230,
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // File
                    TSectionHeading(
                      title: 'Import Audios & Video',
                      onPressed: () => {},
                      showActionButton: false,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 1.5),

                    // Brands GRID
                    TGridLayout(
                      itemCount: 4,
                      mainAxisExtent: 50,
                      itemBuilder: (_, index) {
                        final titles = ['Audio', 'Camera', 'Image', 'Text'];
                        final icons = [Iconsax.microphone, Iconsax.camera, Iconsax.gallery, Iconsax.document_text];
                        return TBrandCard(
                          showBorder: true,
                          title: titles[index],
                          iconData: icons[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Tab
              bottom: TTabBar(
                tabs: [
                  Tab(text: 'Audio Summary'),
                  Tab(text: 'Image Summary'),
                  Tab(text: 'Text Summary'),
                ],
                currentIndex: currentTab,
                onTap: (value) {
                  setState(() {
                    currentTab = value;
                  });
                },
                selectedColor: TColors.primary,
                unselectedColor: Colors.grey.shade200,
                selectedTextColor: Colors.white,
                unselectedTextColor: Colors.black,
              ),
            ),
          ];
        },

        // Body
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),
          ],
        ),
      )),
    );
  }
}
