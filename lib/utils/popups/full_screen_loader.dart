import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';
import '../loaders/animation_loader.dart';

/// A utility class for managing a full-screen loading dialog.
class TFullScreenLoader {
  /// Returns a loading widget that can be used in the widget tree
  static Widget loadingWidget(BuildContext context, String text, String animation) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.white,
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TAnimationLoaderWidget(text: text, animation: animation),
        ],
      ),
    );
  }

  /// Open a full-screen loading dialog with a given text and animation
  static void openLoadingDialog(BuildContext context, String text, String animation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: loadingWidget(context, text, animation),
      ),
    );
  }

  /// Stop the currently open loading dialog
  static void stopLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}