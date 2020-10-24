import 'package:flutter/material.dart';

class AboutDialogButton extends StatelessWidget {
  const AboutDialogButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info),
      tooltip: 'About',
      onPressed: () => showAboutDialog(
        context: context,
        applicationVersion: '1.0.0',
        applicationLegalese: 'A sample application for firebase services',
      ),
    );
  }
}
