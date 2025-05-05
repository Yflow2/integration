import 'package:flutter/material.dart';
import 'package:intern/prathamCode/bottom_menu_component/bottom_menu_container.dart';
import 'package:intern/prathamCode/bottom_menu_component/radial_menu_widget.dart';
import 'package:intern/prathamCode/text_speech_page.dart';
import 'dart:math';
import 'dart:developer' as dev;
import '../updatedRadial/radialMenuSelection.dart';
import 'bottom_sheet_after_api.dart';
import 'custom_dialog_widget.dart';
import 'custom_mic_widget.dart';
import 'language_bottom_sheet.dart';
import 'language_bottom_sheet_pratham.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> with TickerProviderStateMixin {
  bool isKeyboardDisabled = true;
  late AnimationController _toggleController;
  late AnimationController moretoggleController;
  late AnimationController radialController;
  bool isOpen = false;
  bool isExpanded = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _toggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isKeyboardDisabled = false;
          _toggleController.forward();
        });
      }
    });

    moretoggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    radialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }




  /*  void toggleDialog() {
   dev.log("More Button clicked");
   isOpen = !isOpen;
   setState(() {
     if (isOpen) {
       moretoggleController.reset();
       moretoggleController.forward();
       dev.log("Animation Status: ${moretoggleController.status}");
     } else {
       moretoggleController.reverse();
     }
   });
 }*/


  @override
  void dispose() {
    super.dispose();
    _toggleController.dispose();
    _focusNode.dispose();
    moretoggleController.dispose();
    radialController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // Your main content (can be anything)
            Container(color: Colors.white),

            /*Positioned(
             bottom: MediaQuery.sizeOf(context).height * 0.15,
             left: 0,
             right: 0,
             child: AnimatedDialog(
               controller: moretoggleController,
               icons: [
                 Icons.language,
                 Icons.settings,
               ],
               labels: [
                 'Language',
                 'Settings',
               ],
               onTaps: [
                 showMessageFroLanguages,
                 showMessageForSetting
               ],
             ),
           ),*/

            //Radial Menu
            RadialMenuWidget(isExpanded: isExpanded,),

            // Bottom Menu
            BottomMenuContainer(isKeyboardDisabled: isKeyboardDisabled, focusNode: _focusNode,),
          ],

        ),
      ),
    );
  }
}

class ProgressRectClipper extends CustomClipper<Rect> {
  final double currentProgress;

  ProgressRectClipper({required this.currentProgress});

  @override
  Rect getClip(Size size) {
    final width = size.width * currentProgress;
    return Rect.fromLTWH(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
