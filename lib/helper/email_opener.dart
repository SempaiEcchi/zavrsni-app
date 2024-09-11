import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

Future<void> openEmail(context) async {
  // Android: Will open mail app or show native picker.
  // iOS: Will open mail app if single mail app found.
  var result = await OpenMailApp.openMailApp();

  // If no mail apps found, show error
  if (!result.didOpen && !result.canOpen) {
    _showNoMailAppsDialog(context);

    // iOS: if multiple mail apps found, show dialog to select.
    // There is no native intent/default app system in iOS so
    // you have to do it yourself.
  } else if (!result.didOpen && result.canOpen) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
          );
        },
      );
    }

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => _PickMailPopup(result.options),
    );
  }
}

class _PickMailPopup extends StatelessWidget {
  final List<MailApp> options;

  const _PickMailPopup(this.options);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        ...options.map((e) {
          return CupertinoActionSheetAction(
            onPressed: () {
              OpenMailApp.openSpecificMailApp(e);
            },
            child: Text(e.name),
          );
        }),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Odustani'),
        ),
      ],
    );
  }
}

void _showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Open Mail App"),
        content: const Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
