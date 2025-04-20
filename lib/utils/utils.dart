import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/router/router_imports.gr.dart';

class Utils {

  static Map<String, dynamic> convertDeltaToWebFormat(List<Map<String, dynamic>> delta) {
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

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
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
}
