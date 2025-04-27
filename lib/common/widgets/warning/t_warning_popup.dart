import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class TWarningPopup {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
                child: Text(confirmText),
              ),
            ),
          ],
        );
      },
    );
  }
}
