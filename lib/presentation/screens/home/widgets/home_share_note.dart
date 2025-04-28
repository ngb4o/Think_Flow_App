part of 'widget_imports.dart';

class HomeShareNote extends StatefulWidget {
  const HomeShareNote({super.key});

  @override
  State<HomeShareNote> createState() => _HomeShareNoteState();
}

class _HomeShareNoteState extends State<HomeShareNote> {
  String _selectedAccess = 'read';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: EdgeInsets.all(TSizes.sm),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Share This Note',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Share note via e-mail', style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: TSizes.sm),
                      TextFormField(
                        controller: null,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.password_check),
                          labelText: TTexts.email,
                        ),
                      ),
                      SizedBox(height: TSizes.sm),
                      Text('Access Permissions', style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: TSizes.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('View only'),
                              value: 'read',
                              groupValue: _selectedAccess,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAccess = value.toString();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Can edit'),
                              value: 'write',
                              groupValue: _selectedAccess,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAccess = value.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: TSizes.sm),
                      Text('Shared with anyone', style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: TSizes.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              side: WidgetStateProperty.all(BorderSide(color: TColors.primary)),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(Iconsax.copy),
                                SizedBox(width: TSizes.sm),
                                Text(
                                  'Coppy link',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.primary),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: TSizes.md),
                              child: Row(
                                children: [
                                  Icon(Iconsax.direct_right, color: TColors.white),
                                  SizedBox(width: TSizes.sm),
                                  Text(
                                    'Send',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
