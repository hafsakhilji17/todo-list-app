

import 'package:aicp_internship_projects/main.dart';
import 'package:aicp_internship_projects/views/home/components/home_app_bar.dart';
import 'package:aicp_internship_projects/views/home/components/slider_drawer.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import 'package:aicp_internship_projects/extensions/space_exs.dart';
import 'package:aicp_internship_projects/utils/constants.dart';
import 'package:aicp_internship_projects/views/home/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/task.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../components/fab.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();




  // Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  // Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    var themeText = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));
          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: Fab(),
              body: SliderDrawer(
                  key: drawerKey,
                  isDraggable: false,
                  animationDuration: 1000,
                  //Slider Drawer
                  slider: CustomDrawer(),
                  appBar: HomeAppBar(
                    drawerKey: drawerKey,
                  ),
                  //Main Body
                  child: _buildHomeBody(themeText, base,tasks)));
        });
  }

//Home body
  Widget _buildHomeBody(TextTheme themeText,
      BaseWidget base,
  List<Task>tasks
      ) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            //custom app bar
            Container(
              margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                      backgroundColor: Colors.grey,
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),
                  //space
                  25.w,
                  //top level task info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStr.mainTitle,
                        style: themeText.displayLarge,
                      ),
                      3.h,
                      Text('${checkDoneTask(tasks )} of${tasks.length }', style: themeText.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Divider(
                thickness: 2,
                indent: 100,
              ),
            ),
            //tasks
            SizedBox(
              width: double.infinity,
              height: 500,
              child: tasks.isNotEmpty
                  //this task is not empty
                  ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                      itemCount: tasks.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        var task = tasks[index];
                        return Dismissible(
                            direction: DismissDirection.horizontal,
                            onDismissed: (_) {

                              base.dataStore.dalateTask(task:task);
                            },
                            background: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                                8.w,
                                const Text(
                                  AppStr.deletedTask,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            key: Key(task.id),
                            child: TaskWidget(
                              task: task
                            ));
                      })
                  //Task list is empty
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Lottie animation
                        FadeIn(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Lottie.asset(lottieURL,
                                animate: tasks.isNotEmpty ? false : true),
                          ),
                        ),
                        //Sub text
                        FadeInUp(
                            from: 30, child: const Text(AppStr.doneAllTask))
                      ],
                    ),
            ),
          ],
        ));
  }
}
