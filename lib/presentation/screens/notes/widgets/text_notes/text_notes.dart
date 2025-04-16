part of 'text_notes_imports.dart';

@RoutePage()
class TextNotesPage extends StatefulWidget {
  const TextNotesPage({super.key});

  @override
  State<TextNotesPage> createState() => _TextNotesPageState();
}

class _TextNotesPageState extends State<TextNotesPage> {
  final TextEditingController _titleController = TextEditingController();
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

  _createNewNote() {
    context.read<TextNotesBloc>().add(
          TextNotesClickButtonCreateNewEvent(
            title: _titleController.text,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextNotesBloc, TextNotesState>(
      listenWhen: (previous, current) => current is TextNotesActionState,
      buildWhen: (previous, current) => current is! TextNotesActionState,
      listener: (context, state) {
        if (state is TextNotesCreateNewSuccessActionState) {
          // After creating the note, create the text content
          context.read<TextNotesBloc>().add(
                TextNotesClickButtonCreateTextEvent(
                  id: state.noteId,
                  content: _convertDeltaToWebFormat(_quillController.document.toDelta().toJson()),
                ),
              );
        } else if (state is TextNotesCreateTextSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Create successfully');
        } else if (state is TextNotesCreateTextSuccessState) {
          Navigator.pop(context);
        } else if (state is TextNotesCreateNewErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Create error', message: state.message);
        } else if (state is TextNotesCreateTextErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Create error', message: state.message);
        } else if (state is TextNotesNotifyHomeUpdateActionState) {
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
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
                    // Text formatting
                    showHeaderStyle: true,
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: true,

                    // Alignment
                    showAlignmentButtons: true,
                    showLeftAlignment: true,
                    showCenterAlignment: true,
                    showRightAlignment: true,
                    showJustifyAlignment: true,

                    // Lists
                    showListBullets: true,
                    showListNumbers: true,

                    // Other tools
                    showQuote: true,
                    showLink: true,
                    showUndo: true,
                    showRedo: true,

                    // Disable everything else
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
