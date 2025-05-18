part of 'text_notes_imports.dart';


@RoutePage()
class TextNotesPage extends StatefulWidget {
  const TextNotesPage({super.key});

  @override
  State<TextNotesPage> createState() => _TextNotesPageState();
}

class _TextNotesPageState extends State<TextNotesPage> {
  late QuillController _quillController;
  final TextRecognizerService _textRecognizerService = TextRecognizerService();

  Future<void> _processImage(ImageSource source) async {
    try {
      final recognizedText = await _textRecognizerService.processImage(source);
      if (recognizedText != null) {
        final doc = _quillController.document;
        _quillController.document.insert(doc.length - 1, recognizedText + '\n');
        setState(() {}); 
      }
    } catch (e) {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'Failed to process image');
    }
  }
  
  void importImageBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera, size: 25),
              title: Text('Take photo', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _processImage(ImageSource.camera);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Iconsax.gallery, size: 25),
              title: Text('Choose from gallery', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _processImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _quillController = QuillController(
      document: Document()..insert(0, ''),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    _textRecognizerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listenWhen: (previous, current) => current is NotesActionState,
      buildWhen: (previous, current) => current is! NotesActionState,
      listener: (context, state) {
        if (state is NotesCreateSuccessActionSate) {
          final delta = _quillController.document.toDelta().toJson();
          final content = delta.isEmpty
              ? Utils.getEmptyContent()
              : Utils.convertDeltaToContent(delta);

          context.read<NotesBloc>().add(
                NoteCreateTextEvent(
                  id: state.id,
                  content: content,
                ),
              );
          TLoaders.successSnackBar(context, title: 'Create success');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: TSizes.spaceBtwItems * 3),
                    QuillEditor.basic(
                      controller: _quillController,
                      config: QuillEditorConfig(
                        autoFocus: true,
                        expands: false,
                        padding: const EdgeInsets.all(TSizes.sm),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: QuillSimpleToolbar(
                          controller: _quillController,
                          config: QuillSimpleToolbarConfig(
                            color: Colors.transparent,
                            multiRowsDisplay: false,
                            showAlignmentButtons: true,
                            showFontFamily: false,
                            showFontSize: false,
                            showInlineCode: false,
                            showColorButton: false,
                            showBackgroundColorButton: false,
                            showClearFormat: false,
                            showListCheck: false,
                            showCodeBlock: false,
                            showIndent: false,
                            showSearchButton: false,
                            showSubscript: false,
                            showSuperscript: false,
                            showBoldButton: true,
                            showItalicButton: true,
                            showUnderLineButton: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.gallery_import4),
                        onPressed: () => importImageBottomSheet(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
