import 'package:flutter/material.dart';
import '../../../data/models/text_note_model.dart';

class TFormattedText extends StatelessWidget {
  const TFormattedText({
    super.key,
    required this.content,
  });

  final TextContentContent content;

  @override
  Widget build(BuildContext context) {
    if (content.content == null) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildTextContent(content.content!),
    );
  }

  List<Widget> _buildTextContent(List<PurpleContent> content) {
    List<Widget> widgets = [];
    List<Widget> currentLine = [];

    for (var textContent in content) {
      TextStyle style = const TextStyle();
      
      if (textContent.marks != null) {
        for (var mark in textContent.marks!) {
          switch (mark.type) {
            case 'bold':
              style = style.copyWith(fontWeight: FontWeight.bold);
              break;
            case 'italic':
              style = style.copyWith(fontStyle: FontStyle.italic);
              break;
            case 'underline':
              style = style.copyWith(decoration: TextDecoration.underline);
              break;
          }
        }
      }

      String text = textContent.text ?? '';
      if (text.contains('\n')) {
        List<String> parts = text.split('\n');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            currentLine.add(
              Text(
                parts[i],
                style: style,
              ),
            );
          }
          if (i < parts.length - 1) {
            widgets.add(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...currentLine],
              ),
            );
            currentLine = [];
          }
        }
      } else {
        currentLine.add(
          Text(
            text,
            style: style,
          ),
        );
      }
    }

    if (currentLine.isNotEmpty) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: currentLine,
        ),
      );
    }

    return widgets;
  }
} 