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

  _updateText(String textId) {
    final delta = _quillController.document.toDelta().toJson();
    final content = {
      "text_content": [
        {
          "body": {
            "type": "doc",
            "content": delta.map((op) {
              if (op['insert'] == '\n') {
                return {"type": "paragraph", "content": []};
              }
              return {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": op['insert'],
                    "marks": op['attributes'] != null
                        ? (op['attributes'] as Map<String, dynamic>).entries.map((e) => {"type": e.key}).toList()
                        : []
                  }
                ]
              };
            }).toList()
          }
        }
      ]
    };

    context.read<NoteDetailBloc>().add(
          NoteClickButtonUpdateTextEvent(
            noteId: textId,
            content: content,
          ),
        );
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<NoteDetailBloc, NoteDetailState>(
      listenWhen: (previous, current) => current is NoteDetailActionState,
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      listener: (context, state) {
        if (state is NoteUpdateTextSuccessActionSate) {
          setState(() {
            _isEditing = false;
          });
          _loadTextContent();
        } else if (state is NoteUpdateErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        }
      },
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

        return Stack(
          children: [
            SingleChildScrollView(
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
            ),
            if (state is NoteUpdateTextLoadingState)
              Positioned(
                bottom: 10,
                right: 0,
                child: LoadingSpinkit.loadingButton,
              )
            else
              Positioned(
                bottom: 10,
                right: 0,
                child: GestureDetector(
                  onTap: () => _updateText(_cachedTextNoteModel!.data!.id.toString()),
                  child: Container(
                    decoration: BoxDecoration(color: TColors.primary, borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
                    child: Text('Save', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.white)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
