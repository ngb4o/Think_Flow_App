// import 'package:flutter/material.dart';
// import '../../../data/models/text_note_model.dart';
//
// class TFormattedText extends StatelessWidget {
//   const TFormattedText({
//     super.key,
//     required this.content,
//   });
//
//   final TextContentContent content;
//
//   @override
//   Widget build(BuildContext context) {
//     if (content.content == null) return const SizedBox();
//
//     return RichText(
//       text: TextSpan(
//         children: _buildTextSpans(content.content!),
//       ),
//     );
//   }
//
//   List<TextSpan> _buildTextSpans(List<PurpleContent> content) {
//     List<TextSpan> spans = [];
//
//     for (var textContent in content) {
//       TextStyle style = const TextStyle(color: Colors.black);
//
//       if (textContent.marks != null) {
//         for (var mark in textContent.marks!) {
//           switch (mark.type) {
//             case 'bold':
//               style = style.copyWith(fontWeight: FontWeight.bold);
//               break;
//             case 'italic':
//               style = style.copyWith(fontStyle: FontStyle.italic);
//               break;
//             case 'underline':
//               style = style.copyWith(decoration: TextDecoration.underline);
//               break;
//           }
//         }
//       }
//
//       String text = textContent.text ?? '';
//       spans.add(TextSpan(
//         text: text,
//         style: style,
//       ));
//     }
//
//     return spans;
//   }
// }