import 'package:auto_route/auto_route.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../data/models/text_note_model.dart';
import '../presentation/router/router_imports.gr.dart';

class Utils {
  static Map<String, dynamic> getEmptyContent() {
    return {
      "text_content": [
        {
          "body": {
            "type": "doc",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "",
                    "marks": []
                  }
                ]
              }
            ]
          }
        }
      ],
      "text_string": ""
    };
  }

  static Map<String, dynamic> convertDeltaToContent(List<Map<String, dynamic>> delta) {
    String plainText = '';
    List<Map<String, dynamic>> paragraphs = [];
    Map<String, dynamic> currentParagraph = {
      "type": "paragraph",
      "attrs": {"textAlign": null},
      "content": []
    };
    
    for (var op in delta) {
      if (op['insert'] == '\n') {
        if (currentParagraph['content'].isNotEmpty) {
          paragraphs.add(currentParagraph);
          currentParagraph = {
            "type": "paragraph",
            "attrs": {"textAlign": null},
            "content": []
          };
        }
        plainText += '\n';
      } else {
        String text = op['insert'];
        plainText += text;
        
        Map<String, dynamic> textNode = {
          "type": "text",
          "text": text,
        };

        if (op['attributes'] != null) {
          List<Map<String, dynamic>> marks = [];
          Map<String, dynamic> attributes = op['attributes'];
          
          if (attributes['bold'] == true) {
            marks.add({"type": "bold"});
          }
          if (attributes['italic'] == true) {
            marks.add({"type": "italic"});
          }
          if (attributes['underline'] == true) {
            marks.add({"type": "underline"});
          }
          if (attributes['strike'] == true) {
            marks.add({"type": "strike"});
          }
          
          if (marks.isNotEmpty) {
            textNode['marks'] = marks;
          }
        }
        
        currentParagraph['content'].add(textNode);
      }
    }
    
    // Add the last paragraph if it has content
    if (currentParagraph['content'].isNotEmpty) {
      paragraphs.add(currentParagraph);
    }

    return {
      "text_content": [
        {
          "body": {
            "type": "doc",
            "content": paragraphs
          }
        }
      ],
      "text_string": plainText.trim()
    };
  }
  
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  static Future<void> screenRedirect(context) async {
    var isFirstTime = await getIsFirstTime();
    var isLoggedIn = await getIsLoggedIn();

    if (isFirstTime) {
      AutoRouter.of(context).replace(OnboardingScreenRoute());
    } else if (isLoggedIn) {
      AutoRouter.of(context).replace(NavigationMenuRoute());
    } else {
      AutoRouter.of(context).replace(LoginScreenRoute());
    }
  }

  static Future<void> saveCookie(String cookie) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cookie", cookie);
  }

  static Future<String?> getCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("cookie");
  }

  static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  static Future<void> setIsFirstTime(bool isFirstTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTime', isFirstTime);
  }

  static Future<bool> getIsFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    return isFirstTime;
  }

  static Future<void> clearAllSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    await prefs.clear();

    await prefs.setBool('isFirstTime', isFirstTime);
  }

  static Delta convertProseMirrorToDelta(List<TextContent>? content) {
    if (content == null || content.isEmpty) return Delta()..insert('\n');

    final bodyContent = content[0].body?.content;
    if (bodyContent == null || bodyContent.isEmpty) return Delta()..insert('\n');

    final delta = Delta();

    for (var paragraph in bodyContent) {
      if (paragraph.content == null || paragraph.content!.isEmpty) {
        delta.insert('\n');
        continue;
      }

      for (var textContent in paragraph.content!) {
        String text = textContent.text ?? '';
        List<Mark>? marks = textContent.marks;

        Map<String, dynamic> attributes = {};
        if (marks != null) {
          for (var mark in marks) {
            switch (mark.type) {
              case MarkType.BOLD:
                attributes['bold'] = true;
                break;
              case MarkType.ITALIC:
                attributes['italic'] = true;
                break;
              case MarkType.UNDERLINE:
                attributes['underline'] = true;
                break;
              case MarkType.STRIKE:
                attributes['strike'] = true;
                break;
              case null:
                break;
            }
          }
        }

        delta.insert(text, attributes);
      }
      // Add newline after each paragraph
      delta.insert('\n');
    }

    return delta;
  }

  static String convertProseMirrorToHtml(List<TextContent>? content) {
    if (content == null || content.isEmpty) return '';

    final bodyContent = content[0].body?.content;
    if (bodyContent == null || bodyContent.isEmpty) return '';

    final StringBuffer html = StringBuffer();
    html.write('<p>');

    bool isFirstParagraph = true;
    for (var paragraph in bodyContent) {
      if (paragraph.content == null || paragraph.content!.isEmpty) {
        html.write('<br>');
        continue;
      }

      if (!isFirstParagraph) {
        html.write('</p><p>');
      }
      isFirstParagraph = false;

      for (var textContent in paragraph.content!) {
        String text = textContent.text ?? '';
        text = text.replaceAll('\n', '<br>');

        List<Mark>? marks = textContent.marks;

        String styledText = text;
        if (marks != null) {
          for (var mark in marks) {
            switch (mark.type) {
              case MarkType.BOLD:
                styledText = '<strong>$styledText</strong>';
                break;
              case MarkType.ITALIC:
                styledText = '<em>$styledText</em>';
                break;
              case MarkType.UNDERLINE:
                styledText = '<u>$styledText</u>';
                break;
              case MarkType.STRIKE:
                styledText = '<s>$styledText</s>';
                break;
              case null:
                break;
            }
          }
        }
        html.write(styledText);
      }
    }

    html.write('</p>');
    return html.toString();
  }

  static Widget buildSummaryText(BuildContext context, String text) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.isEmpty) return const SizedBox(height: 8);

        // Check the level of the line and replace numbers with bullets
        if (line.startsWith(RegExp(r'^\d+\.\s'))) {
          // Main level (1., 2., etc.)
          final content = line.replaceFirst(RegExp(r'^\d+\.\s'), '');
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          );
        } else if (line.startsWith(RegExp(r'^\d+\.\d+\.\s'))) {
          // Sub level (1.1., 2.1., etc.)
          final content = line.replaceFirst(RegExp(r'^\d+\.\d+\.\s'), '• ');
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(content, style: Theme.of(context).textTheme.bodyLarge),
          );
        } else if (line.startsWith(RegExp(r'^\d+\.\d+\.\d+\.\s'))) {
          // Sub-sub level (1.1.1., etc.)
          final content =
              line.replaceFirst(RegExp(r'^\d+\.\d+\.\d+\.\s'), '• ');
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          // Regular text
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      }).toList(),
    );
  }
}
