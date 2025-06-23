import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TQuillToolBar extends StatelessWidget {
  const TQuillToolBar({super.key, required this.quillController});

  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
      controller: quillController,
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
    );
  }
}
