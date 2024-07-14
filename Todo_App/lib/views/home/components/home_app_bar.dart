import 'package:aicp_internship_projects/main.dart';
import 'package:aicp_internship_projects/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerKey});

  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animatedController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    animatedController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    animatedController.dispose();
    super.dispose();
  }
//OnToggle
  void onDrawerToggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        animatedController.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        animatedController.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var base = BaseWidget.of(context).dataStore.box;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 100,

        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu Icon
              IconButton(
                onPressed: onDrawerToggle,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: animatedController,
                  size: 40,
                ),
              ),
              // Trash Icon
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: (){
                    deleteAllTask(context);
                  },
                  icon: Icon(
                    CupertinoIcons.trash_fill,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
