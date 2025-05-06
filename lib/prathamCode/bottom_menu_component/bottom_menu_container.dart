import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_more_wigdet/more_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_more_wigdet/more_event.dart';

import '../bottomApp.dart';
import '../bottom_sheet_after_api.dart';
import '../custom_mic_widget.dart';
import '../language_bottom_sheet_pratham.dart';
import '../text_speech_page.dart';

class BottomMenuContainer extends StatefulWidget {
  final isKeyboardDisabled;
  final focusNode;

  const BottomMenuContainer({super.key, required this.isKeyboardDisabled,required this.focusNode});

  @override
  State<BottomMenuContainer> createState() => _BottomMenuContainerState();
}

class _BottomMenuContainerState extends State<BottomMenuContainer> with TickerProviderStateMixin {
  late bool isKeyboardDisabled;
  final FocusNode focusNode = FocusNode();
  late AnimationController toggleController;

  @override
  void initState() {
    super.initState();
    isKeyboardDisabled = widget.isKeyboardDisabled;

    toggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );


    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isKeyboardDisabled = false;
          toggleController.forward();
        });
      }
    });
  }



  void showMessage()  {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FullScreenBottomSheet(),
      isDismissible: false,
      enableDrag: false,
    );
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          bottom: max(
            0,
            MediaQuery.of(context).viewInsets.bottom -
                MediaQuery.sizeOf(context).height * 0.4,
          ),
        ),
        child: Container(
          height:
              width > 400
                  ? height * 0.3
                  : MediaQuery.sizeOf(context).height * 0.15,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.yellow.shade100,
          child:
              isKeyboardDisabled
                  ? LayoutBuilder(
                    builder: (BuildContext ctx, BoxConstraints constraints) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(focusNode);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: constraints.maxHeight * 0.35,
                                    left: constraints.maxWidth * 0.1,
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_alt_outlined,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.35,
                                  right: constraints.maxWidth * 0.1,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: () {
                                    dev.log("Button pressed");
                                    context
                                        .read<MoreBloc>()
                                        .add(ToggleMenuEvent());
                                    /*toggleMenu();*/
                                  },
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: constraints.maxHeight * 0.15,
                            left: 0,
                            right: 0,
                            child: CustomMicWidget(
                              width: 300,
                              height: 400,
                              blurRadius: 0,
                              spreadRadius: 0,
                              onButtonPressed: () {
                                showMessage();
                              },
                              disabled: true,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                  : AnimatedBuilder(
                    animation: toggleController,
                    builder: (context, child) {
                      return ClipRect(
                        clipper: ProgressRectClipper(
                          currentProgress: toggleController.value,
                        ),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.15,
                          width: MediaQuery.sizeOf(context).width,
                          child: LayoutBuilder(
                            builder: (
                              BuildContext ctx,
                              BoxConstraints constraints,
                            ) {
                              return Row(
                                mainAxisAlignment:
                                    width > 400
                                        ? MainAxisAlignment.spaceAround
                                        : MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: constraints.maxWidth * 0.02,
                                      ),
                                      child: SizedBox(
                                        width: constraints.maxWidth * 0.60,
                                        child: TextField(
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 2.0,
                                              ),
                                            ),
                                            suffixIcon: const Icon(Icons.send),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isKeyboardDisabled = true;
                                            toggleController.reverse();
                                            FocusScope.of(context).unfocus();
                                          });
                                        },
                                        child: CustomMicWidget(
                                          blurRadius: 0,
                                          spreadRadius: 0,
                                          disabled: true,
                                        ),
                                      ),
                                      width > 400
                                          ? SizedBox(
                                            width: constraints.maxWidth * 0.02,
                                          )
                                          : SizedBox(
                                            width: constraints.maxWidth * 0,
                                          ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: constraints.maxWidth * 0.01,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.more_horiz),
                                          onPressed: () {
                                            /*toggleMenu();*/
                                            context
                                                .read<MoreBloc>()
                                                .add(ToggleMenuEvent());
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
