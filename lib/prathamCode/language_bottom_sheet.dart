

import 'package:flutter/material.dart';

void showLanguageBottomSheet(BuildContext context) {

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text('English'),
              onTap: () {
                // Handle language selection
                Navigator.pop(context, 'English');
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Spanish'),
              onTap: () {
                // Handle language selection
                Navigator.pop(context, 'Spanish');
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('French'),
              onTap: () {
                // Handle language selection
                Navigator.pop(context, 'French');
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('German'),
              onTap: () {
                // Handle language selection
                Navigator.pop(context, 'German');
              },
            ),
            // Add more languages as needed
          ],
        ),
      );
    },
  ).then((value) {
    if (value != null) {
      // Handle the selected language
      print('Selected language: $value');
    }
  });
}