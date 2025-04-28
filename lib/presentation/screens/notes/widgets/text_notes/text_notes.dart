part of 'text_notes_imports.dart';

@RoutePage()
class TextNotesPage extends StatefulWidget {
  const TextNotesPage({super.key});

  @override
  State<TextNotesPage> createState() => _TextNotesPageState();
}

class _TextNotesPageState extends State<TextNotesPage> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _quillController.dispose();
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
          final content = Utils.convertDeltaToContent(delta);
          
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
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: TSizes.spaceBtwItems),
              QuillSimpleToolbar(
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
              SizedBox(
                height: THelperFunctions.screenHeight(context),
                child: QuillEditor.basic(
                  controller: _quillController,
                  config: QuillEditorConfig(
                    padding: EdgeInsets.all(TSizes.sm),
                    expands: true,
                    scrollable: true,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
