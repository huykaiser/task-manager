import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/extensions/space_exs.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_str.dart';
import 'package:task_manager/utils/constants.dart';
import 'package:task_manager/views/tasks/widget/task_view_app_bar.dart';
import '../../models/task.dart';
import 'components/date_time_selection.dart';
import 'components/rep_textfield.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      required this.titleTaskController,
      required this.descriptionTaskController,
      required this.task});

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  // show selected time as string format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  // show selected date as string format
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

  // show selected date as DateFormat for init Time
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

  // if any task already exist return true otherwise false
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  // main function for creating or updating tasks
  dynamic isTaskAlreadyExitsUpdateOtherWiseCreate(){
    // update current task
    if(widget.titleTaskController?.text != null && widget.descriptionTaskController?.text != null){
      try{
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();
        Navigator.pop(context);
      }catch(e){
        // if user want to update task but entered nothing, we will show this warning
        updateTaskWarning(context);
      }
    }
    // create a new task
    else{
      if(title!=null && subTitle != null){
        var task = Task.create(
          title: title,
          subtitle: subTitle,
          createdAtDate: date,
          createdAtTime: time,
        );

        // add this new task to hive db using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.pop(context);
      }else{
        emptyWarning(context);
      }
    }
  }

  // delete task
  dynamic deleteTask(){
    return widget.task?.delete();
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
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // top side texts
                _buildTopSizeTexts(textTheme),
                // main task view activity
                _buildMainTaskViewActivity(textTheme, context),
                // bottom side buttons
                _buildBottomSideButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bottom side buttons
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist() ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist() ? Container() :
          // delete current task button
          MaterialButton(
            onPressed: () {
              // log("Current task has been deleted!");

              deleteTask();
              Navigator.pop(context);
            },
            minWidth: 150,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            height: 55,
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                ),
                5.w,
                const Text(
                  AppStr.deleteTask,
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ],
            ),
          ),

          // add or update task button
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExitsUpdateOtherWiseCreate();
              // log("New task has been added!");
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            height: 55,
            child: Text(
              isTaskAlreadyExist()
                  ? AppStr.addTaskString
                : AppStr.updateTaskString,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // main task view activity
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 500,
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

          // task title
          RepTextField(
            controller: widget.titleTaskController,
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),
          10.h,
          // task description
          RepTextField(
            controller: widget.descriptionTaskController,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          // time selection
          DateTimeSelectionWidget(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => SizedBox(
                          height: 280,
                          child: TimePickerWidget(
                              initDateTime: showDateAsDateTime(date),
                              onChange: (_, __) {},
                              dateFormat: 'HH:mm',
                              onConfirm: (dateTime, _) {
                                setState(() {
                                  if (widget.task?.createdAtDate == null) {
                                    time = dateTime;
                                  } else {
                                    widget.task!.createdAtDate = dateTime;
                                  }
                                });
                              }),
                        ));
              },
              title: AppStr.timeString,
              isTime: true,
              time: showTime(time)),

          // date selection
          DateTimeSelectionWidget(
              onTap: () {
                DatePicker.showDatePicker(context,
                    maxDateTime: DateTime(2030, 4, 5),
                    minDateTime: DateTime.now(),
                    initialDateTime: showDateAsDateTime(date),
                    onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtTime == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                });
              },
              title: AppStr.dateString,
              time: showDate(date)),
        ],
      ),
    );
  }

  // top side texts
  Widget _buildTopSizeTexts(TextTheme textTheme) {
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
                      ? AppStr.addNewTask
                      : AppStr.updateCurrentTask,
                  style: textTheme.titleLarge,
                  children: const [
                TextSpan(
                    text: AppStr.taskString,
                    style: TextStyle(fontWeight: FontWeight.w400))
              ])),
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
