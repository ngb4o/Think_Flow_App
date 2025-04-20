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
        if (state is NotesCreateTextActionState) {
          context.read<NotesBloc>().add(
                NoteCreateTextEvent(
                  id: state.id,
                  content: Utils.convertDeltaToWebFormat(_quillController.document.toDelta().toJson()),
                ),
              );
        }
      },
      builder: (context, state) {
        return SizedBox.expand(
          child: SingleChildScrollView(
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
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QuillEditor.basic(
                    controller: _quillController,
                    config: QuillEditorConfig(
                      padding: EdgeInsets.all(TSizes.spaceBtwItems),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
