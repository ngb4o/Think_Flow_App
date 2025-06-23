part of '../widget_imports.dart';

class TextDetailTab extends StatefulWidget {
  const TextDetailTab({
    super.key,
    required this.noteId,
    required this.permission,
    required this.titleNote,
  });

  final String noteId;
  final String permission;
  final String titleNote;

  @override
  State<TextDetailTab> createState() => _TextDetailTabState();
}

class _TextDetailTabState extends State<TextDetailTab>
    with AutomaticKeepAliveClientMixin {
  late QuillController _quillController;
  bool _isEditing = false;
  TextNoteModel? _cachedTextNoteModel;
  final TextRecognizerService _textRecognizerService = TextRecognizerService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _loadTextContent();
  }

  void _loadTextContent() {
    context
        .read<TextNoteDetailBloc>()
        .add(TextNoteDetailInitialFetchDataEvent(noteId: widget.noteId));
  }

  void _enterEditMode() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    if (_cachedTextNoteModel?.data?.textContent != null) {
      final delta = Utils.convertProseMirrorToDelta(
          _cachedTextNoteModel?.data?.textContent);
      _quillController.document = Document.fromDelta(delta);
    }
    setState(() {
      _isEditing = true;
    });
  }

  _updateText(String textId) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    final delta = _quillController.document.toDelta().toJson();
    final content = Utils.convertDeltaToContent(delta);

    context.read<TextNoteDetailBloc>().add(
          TextNoteDetailUpdateEvent(
            noteId: textId,
            content: content,
          ),
        );
  }

  Future<void> _processImage(ImageSource source) async {
    try {
      final recognizedText = await _textRecognizerService.processImage(source);
      if (recognizedText != null) {
        final doc = _quillController.document;
        _quillController.document.insert(doc.length - 1, recognizedText + '\n');
        setState(() {});
      }
    } catch (e) {
      TLoaders.errorSnackBar(context,
          title: 'Error', message: 'Failed to process image');
    }
  }

  void importImageBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm, vertical: TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera, size: 25),
              title: Text('Take photo',
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _processImage(ImageSource.camera);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
              child: const Divider(),
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery, size: 25),
              title: Text('Choose from gallery',
                  style: Theme.of(context).textTheme.bodyLarge),
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
  void dispose() {
    _quillController.dispose();
    _textRecognizerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    super.build(context);
    return BlocConsumer<TextNoteDetailBloc, TextNoteDetailState>(
      listenWhen: (previous, current) => current is TextNoteDetailActionState,
      buildWhen: (previous, current) => current is! TextNoteDetailActionState,
      listener: (context, state) {
        if (state is TextNoteDetailUpdateSuccessActionState) {
          setState(() {
            _isEditing = false;
            _cachedTextNoteModel = null;
            _quillController.document = Document();
          });
          _loadTextContent();
        } else if (state is TextNoteDetailErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is TextNoteDetailNavigationToSummaryActionState) {
          AutoRouter.of(context).push(TextSummaryScreenRoute(
              noteId: widget.noteId,
              permission: widget.permission,
              titleSummary: widget.titleNote));
        }
      },
      builder: (context, state) {
        if (state is TextNoteDetailLoadingState) {
          _cachedTextNoteModel = null;
          _quillController.document = Document();
          return const Center(child: TLoadingSpinkit.loadingPage);
        } else if (state is TextNoteDetailSuccessState) {
          _cachedTextNoteModel = state.textNoteModel;
          final textContent = _cachedTextNoteModel?.data?.textContent;

          if (!_isEditing) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (textContent == null || textContent.isEmpty)
                        GestureDetector(
                          onTap: widget.permission == 'read'
                              ? null
                              : _enterEditMode,
                          child: Column(
                            children: [
                              SizedBox(height: TSizes.spaceBtwSections * 2),
                              Center(
                                child: TEmptyWidget(
                                    subTitle: widget.permission == 'read'
                                        ? 'No content available'
                                        : 'Tap anywhere to start editing'),
                              ),
                            ],
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: widget.permission == 'read'
                              ? null
                              : _enterEditMode,
                          child: html.Html(
                            data: Utils.convertProseMirrorToHtml(textContent),
                            style: {
                              'p': html.Style(
                                margin: html.Margins.zero,
                                padding: html.HtmlPaddings.zero,
                              ),
                              'body': html.Style(
                                fontSize: html.FontSize(15),
                              ),
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: isDarkMode ? TColors.darkerGrey : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SpeedDial(
                      icon: Icons.auto_awesome,
                      activeIcon: Iconsax.close_square,
                      iconTheme: IconThemeData(
                          color: isDarkMode ? TColors.white : TColors.black,
                          size: 30),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      spacing: 10,
                      children: [
                        SpeedDialChild(
                          child: Icon(Iconsax.flash_1),
                          label: 'Summary text',
                          onTap: () {
                            context.read<TextNoteDetailBloc>().add(
                                TextNoteDetailNavigationToSummaryEvent(
                                    textId: _cachedTextNoteModel!.data!.id
                                        .toString(),
                                    permission: widget.permission));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: TSizes.spaceBtwSections * 2),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      QuillEditor.basic(
                        controller: _quillController,
                        config: QuillEditorConfig(),
                      ),
                    ],
                  ),
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
                        child: TQuillToolBar(quillController: _quillController),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.gallery_import4),
                        onPressed: () => importImageBottomSheet(),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is TextNoteDetailUpdateLoadingState)
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: TLoadingSpinkit.loadingButton,
                )
              else
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: GestureDetector(
                    onTap: () =>
                        _updateText(_cachedTextNoteModel!.data!.id.toString()),
                    child: TTextSaveButton(),
                  ),
                ),
            ],
          );
        } else if (state is TextNoteDetailErrorState) {
          return TErrorWidget(subError: state.message);
        }
        return const SizedBox();
      },
    );
  }
}
