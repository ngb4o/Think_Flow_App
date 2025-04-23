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
          final content = {
            "text_content": [{
              "body": {
                "type": "doc",
                "content": delta.map((op) {
                  if (op['insert'] == '\n') {
                    return {
                      "type": "paragraph",
                      "content": []
                    };
                  }
                  return {
                    "type": "paragraph",
                    "content": [{
                      "type": "text",
                      "text": op['insert'],
                      "marks": op['attributes'] != null ? 
                        (op['attributes'] as Map<String, dynamic>).entries.map((e) => {
                          "type": e.key
                        }).toList() : []
                    }]
                  };
                }).toList()
              }
            }]
          };
          
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
                      padding: EdgeInsets.all(TSizes.spaceBtwItems),
                      expands: true,
                      scrollable: true,
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
