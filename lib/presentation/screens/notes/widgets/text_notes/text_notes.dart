part of 'text_notes_imports.dart';

@RoutePage()
class TextNotesPage extends StatefulWidget {
  const TextNotesPage({super.key});

  @override
  State<TextNotesPage> createState() => _TextNotesPageState();
}

class _TextNotesPageState extends State<TextNotesPage> {
  late QuillController _quillController;

  Map<String, dynamic> _convertDeltaToWebFormat(List<Map<String, dynamic>> delta) {
    List<Map<String, dynamic>> content = [];
    List<Map<String, dynamic>> currentParagraph = [];

    for (var op in delta) {
      if (op['insert'] == '\n') {
        if (currentParagraph.isNotEmpty) {
          content.add({
            'type': 'paragraph',
            'attrs': {'textAlign': null},
            'content': currentParagraph
          });
          currentParagraph = [];
        }
      } else {
        Map<String, dynamic> textNode = {'type': 'text', 'text': op['insert']};

        if (op.containsKey('attributes')) {
          List<Map<String, dynamic>> marks = [];
          if (op['attributes']['bold'] == true) {
            marks.add({'type': 'bold'});
          }
          if (op['attributes']['italic'] == true) {
            marks.add({'type': 'italic'});
          }
          if (op['attributes']['underline'] == true) {
            marks.add({'type': 'underline'});
          }
          if (marks.isNotEmpty) {
            textNode['marks'] = marks;
          }
        }

        currentParagraph.add(textNode);
      }
    }

    if (currentParagraph.isNotEmpty) {
      content.add({
        'type': 'paragraph',
        'attrs': {'textAlign': null},
        'content': currentParagraph
      });
    }

    return {'type': 'doc', 'content': content};
  }

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
                  content: _convertDeltaToWebFormat(_quillController.document.toDelta().toJson()),
                ),
              );
        }
      },
      builder: (context, state) {
        return SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              children: [
                QuillSimpleToolbar(
                  controller: _quillController,
                  config: QuillSimpleToolbarConfig(
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
