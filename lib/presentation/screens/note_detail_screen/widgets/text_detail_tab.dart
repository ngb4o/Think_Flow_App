part of 'widget_imports.dart';

class TextDetailTab extends StatefulWidget {
  const TextDetailTab({
    super.key,
    required this.noteId,
  });

  final String noteId;

  @override
  State<TextDetailTab> createState() => _TextDetailTabState();
}

class _TextDetailTabState extends State<TextDetailTab> with AutomaticKeepAliveClientMixin {
  late QuillController _quillController;
  bool _isEditing = false;
  TextNoteModel? _cachedTextNoteModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _loadTextContent();
  }

  void _loadTextContent() {
    context.read<NoteDetailBloc>().add(NoteTextDetailInitialFetchDataEvent(noteId: widget.noteId));
  }

  void _enterEditMode() {
    if (_cachedTextNoteModel?.data?.textContent != null) {
      final delta = Utils.convertProseMirrorToDelta(_cachedTextNoteModel?.data?.textContent);
      _quillController.document = Document.fromDelta(delta);
    }
    setState(() {
      _isEditing = true;
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<NoteDetailBloc, NoteDetailState>(
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      builder: (context, state) {
        if (state is NoteTextDetailLoadingState && _cachedTextNoteModel == null) {
          return const Center(child: LoadingSpinkit.loadingPage);
        }

        if (state is NoteTextDetailSuccessState) {
          _cachedTextNoteModel = state.textNoteModel;
        }

        final textContent = _cachedTextNoteModel?.data?.textContent;
        
        if (!_isEditing) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (textContent == null || textContent.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: TSizes.spaceBtwSections * 2),
                      Center(
                        child: TEmpty(subTitle: 'Tap anywhere to start editing'),
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: _enterEditMode,
                    child: html.Html(
                      data: Utils.convertProseMirrorToHtml(textContent),
                      style: {
                        'p': html.Style(
                          margin: html.Margins.zero,
                          padding: html.HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
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
              QuillEditor.basic(
                controller: _quillController,
                config: QuillEditorConfig(),
              ),
            ],
          ),
        );
      },
    );
  }
}
