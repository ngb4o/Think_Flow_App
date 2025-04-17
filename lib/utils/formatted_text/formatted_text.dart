import 'package:flutter/material.dart';
import 'package:think_flow/data/models/text_note_model.dart';

class TFormattedText extends StatelessWidget {
  final TextContentContent content;

  const TFormattedText({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (content.content == null) return const SizedBox();
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.content!.map((textContent) {
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
        
        return Text(
          textContent.text ?? '',
          style: style,
        );
      }).toList(),
    );
  }
} 