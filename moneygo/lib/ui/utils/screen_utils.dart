import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class ScreenUtils {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function onConfirm,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          titlePadding: const EdgeInsets.all(0.0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          buttonPadding: const EdgeInsets.all(0.0),
          title: Container(
              decoration: const BoxDecoration(
                color: CustomColorScheme.appRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      title,
                      style: CustomTextStyleScheme.dialogTitle,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              )),
          content: SingleChildScrollView(
            child: Center(
              child: Text(content,
                  style: CustomTextStyleScheme.dialogBody,
                  textAlign: TextAlign.center),
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColorScheme.dialogButtonCancel),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.black))),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColorScheme.appRed),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.white)))
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ],
        );
      },
    );

    if (result ?? false) {
      await onConfirm();
    }
  }

  static void showSnackBarAddOrUpdate(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: CustomColorScheme.appGreen,
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  static void showSnackBarDelete(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: CustomColorScheme.appRed,
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}
