
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../updatedRadial/radialMenuSelection.dart';
import '../bloc/bloc_for_more_wigdet/more_bloc.dart';
import '../bloc/bloc_for_more_wigdet/more_state.dart';
import '../bottom_sheet_after_api.dart';
import '../language_bottom_sheet_pratham.dart';

class RadialMenuWidget extends StatefulWidget {
  final isExpanded;
  
  const RadialMenuWidget({required this.isExpanded,super.key});

  @override
  State<RadialMenuWidget> createState() => _RadialMenuWidgetState();
}

class _RadialMenuWidgetState extends State<RadialMenuWidget> with TickerProviderStateMixin{

  late AnimationController radialController;
  late bool isExpanded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    radialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    isExpanded = widget.isExpanded;
  }

  void showLanguages() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return LanguageDialogContent();
      },
    );
  }

  void showSettings(){}

  void showMessageAfterApi() {
    showBottomSheetWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoreBloc, MoreState>(
      listener: (context, state) {
        if (state is BottomSheetIsExpanded) {
          radialController.forward();
        } else if (state is BottomSheetIsHidden) {
          radialController.reverse();
        }
      },
      builder: (context, state) {
        return Positioned(
          bottom: MediaQuery.sizeOf(context).height * 0.15,
          child: RadialMenu(
            controller: radialController,
            icons: [Icons.language, Icons.settings, Icons.file_copy],
            labels: ['Languages', 'Settings', 'Recordings'],
            onTaps: [showLanguages, showSettings, showMessageAfterApi],
          ),
        );
      },
    );
  }
}

