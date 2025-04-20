part of 'widget_imports.dart';

class TextDetailTab extends StatefulWidget {
  const TextDetailTab({
    super.key,
    required this.textContent,
  });

  final TextContent? textContent;

  @override
  State<TextDetailTab> createState() => _TextDetailTabState();
}

class _TextDetailTabState extends State<TextDetailTab> {
  late QuillController _quillController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    if (widget.textContent != null) {
      _loadContent();
    }
  }

  void _loadContent() {
    if (widget.textContent?.content == null) return;

    List<Map<String, dynamic>> delta = [];
    for (var paragraph in widget.textContent!.content!) {
      if (paragraph.content == null) continue;
      
      for (var content in paragraph.content!) {
        Map<String, dynamic> op = {'insert': content.text ?? ''};
        
        if (content.marks != null && content.marks!.isNotEmpty) {
          Map<String, dynamic> attributes = {};
          for (var mark in content.marks!) {
            switch (mark.type) {
              case 'bold':
                attributes['bold'] = true;
                break;
              case 'italic':
                attributes['italic'] = true;
                break;
              case 'underline':
                attributes['underline'] = true;
                break;
            }
          }
          if (attributes.isNotEmpty) {
            op['attributes'] = attributes;
          }
        }
        
        delta.add(op);
      }
      
      // Add newline after each paragraph
      delta.add({'insert': '\n'});
    }

    _quillController.document = Document.fromJson(delta);
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: TSizes.spaceBtwItems),
            if (widget.textContent?.content != null)
              ...widget.textContent!.content!.map(
                (paragraph) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                    child: TFormattedText(content: paragraph),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
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
    );
  }
}
