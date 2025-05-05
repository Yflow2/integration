import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LanguageDialogContent extends StatefulWidget {
  @override
  State<LanguageDialogContent> createState() => _LanguageDialogContentState();
}

class _LanguageDialogContentState extends State<LanguageDialogContent> {
  List<String> languages = [
    'English',
    'Hindi',
    'Marathi',
    'Gujarati',
    'Punjabi',
    'Tamil',
    'Kannada',
    'Malyalam',
  ];
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List<bool>.filled(languages.length, false);
    isSelected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    dev.log(width.toString());

    double height = MediaQuery.sizeOf(context).height;
    dev.log(height.toString());

    return SingleChildScrollView(
      child: Container(
        height:
            MediaQuery.of(context).size.height *
            0.7, // Adjust the height as needed
        padding: EdgeInsets.only(top: 20), // Add some padding at the top
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, -3), // changes position of shadow
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Languages',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: MediaQuery.sizeOf(context).width * 0.08),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.39,
                  color: Colors.yellow,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2.3,
                        ),
                        itemCount: languages.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = (i == index);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isSelected[index]
                                        ? Colors.blueAccent
                                        : Colors.black,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Center(
                                child: Text(
                                  '${languages[index]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.026),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width * 0.55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
