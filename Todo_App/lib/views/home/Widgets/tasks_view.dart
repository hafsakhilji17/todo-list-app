import 'package:aicp_internship_projects/extensions/space_exs.dart';
import 'package:aicp_internship_projects/views/home/components/rep_text_field.dart';
import 'package:flutter/material.dart';
import 'package:aicp_internship_projects/utils/app_colors.dart';
import 'package:aicp_internship_projects/views/home/widgets/task_view_app_bar.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'dart:core';

import '../../../main.dart';
import '../../../models/task.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/constants.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController titleTaskController;
  final TextEditingController descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  // Show selected time as string format
  String showTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Check if task already exists
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  // Show selected date as string format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show selected date as DateTime format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  // Update task if it exists, otherwise create a new one
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    if (widget.titleTaskController.text.isNotEmpty &&
        widget.descriptionTaskController.text.isNotEmpty) {
      if (widget.task != null) {
        // Update existing task
        widget.task!.title = title;
        widget.task!.subtitle = subtitle;
        widget.task!.createdAtDate = date!;
        widget.task!.createdAtTime = time!;
        widget.task!.save();
      } else {
        // Create new task
        var task = Task.create(
          title: title,
          subtitle: subtitle,
          createdAtTime: time,
          createdAtDate: date,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
      }
      Navigator.of(context).pop();
    } else {
      emptyFieldsWarning(context);
    }
  }

  // Delete selected task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  // Delete all tasks from database
  dynamic deleteAllTasks(BuildContext context) {
    return PanaraConfirmDialog.show(context,
        message: "Do you really want to delete all tasks?",
        confirmButtonText: "Yes",
        cancelButtonText: "No",
        onTapConfirm: () {}, onTapCancel: () {
          Navigator.pop(context);
        }, panaraDialogType: PanaraDialogType.warning);
  }

  dynamic noTaskWarning(BuildContext context) {
    return PanaraInfoDialog.showAnimatedGrow(context,
        title: AppStr.oopsMsg,
        message: "There's no task for deleted",
        buttonText: "Okay", onTapDismiss: () {
          Navigator.pop(context);
        }, panaraDialogType: PanaraDialogType.warning);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: const TaskViewAppBar(),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopText(textTheme),
                _buildMiddleTextFieldsANDTimeAndDateSelection(context, textTheme),
                _buildBottomButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build all bottom buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
            mainAxisAlignment: isTaskAlreadyExist()
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            children: [
              isTaskAlreadyExist()
                  ? Container()
                  : MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minWidth: 150,
                height: 55,
                onPressed: () {
                  deleteTask();
                  Navigator.pop(context);
                },
                color: Colors.white,
                child: Row(
                  children: const [
                    Icon(
                      Icons.close,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      AppStr.deleteTask,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minWidth: 150,
                height: 55,
                onPressed: () {
                  isTaskAlreadyExistUpdateOtherWiseCreate();
                },
                color: AppColors.primaryColor,
                child: Text(
                  isTaskAlreadyExist()
                      ? AppStr.updateTaskString
                      : AppStr.addTaskString,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ]));
  }

  /// Build middle text fields and time and date selection
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 535,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),
          RepTaskField(
            controller: widget.titleTaskController,
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
          ),
          10.h,
          RepTaskField(
              controller: widget.descriptionTaskController,
              isForDescription: true,
              onFieldSubmitted: (String inputSubTitle) {
                subtitle = inputSubTitle;
              },
              onChanged: (String inputSubTitle) {
                subtitle = inputSubTitle;
              }),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(
                    height: 280,
                    child: TimePickerWidget(
                      initDateTime: showDateAsDateTime(time),
                      onChange: (DateTime, __) {
                        setState(() {
                          if (widget.task?.createdAtTime == null) {
                            time = DateTime;
                          } else {
                            widget.task!.createdAtTime = DateTime;
                          }
                        });
                      },
                      dateFormat: "HH:mm",
                      onConfirm: (dateTime, _) {},
                    ),
                  ));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(AppStr.timeString, style: textTheme.headlineSmall),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showTime(time),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  maxDateTime: DateTime(2030, 4, 5),
                  minDateTime: DateTime.now(),
                  initialDateTime: showDateAsDateTime(time),
                  onConfirm: (dateTime, _) {
                    setState(() {
                      if (widget.task?.createdAtDate == null) {
                        date = dateTime;
                      } else {
                        widget.task!.createdAtDate = dateTime;
                      }
                    });
                  });
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(AppStr.dateString, style: textTheme.headlineSmall),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showDate(date),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Build top text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExist()
                    ? AppStr.updateCurrentTask
                    : AppStr.addNewTask,
                style: textTheme.titleLarge,
                children: const [
                  TextSpan(
                    text: AppStr.taskStrnig,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar
class TaskViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskViewAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
