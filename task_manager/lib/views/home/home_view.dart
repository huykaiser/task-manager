import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/extensions/space_exs.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/views/home/components/fab.dart';
import 'package:task_manager/views/home/widget/task_widget.dart';

import '../../models/task.dart';
import '../../utils/app_str.dart';
import '../../utils/constants.dart';
import 'components/home_app_bar.dart';
import 'components/slider_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  // final List<int> testing = [];

  // check value of circle indicator
  dynamic valueOfIndicator(List<Task> task){
    if(task.isNotEmpty){
      return task.length;
    }else{
      return 3;
    }
  }

  // check done tasks
  int checkDoneTask(List<Task> tasks){
    int i=0;

    for(Task doneTask in tasks){
      if(doneTask.isCompleted){
        i++;
      }
    }

    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          // for sorting list
          tasks.sort((a,b) => a.createdAtDate.compareTo(b.createdAtDate));

          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: const Fab(),
            body: SliderDrawer(
                key: drawerKey,
                isDraggable: false,
                animationDuration: 1000,
                slider: CustomDrawer(),
                appBar: HomeAppBar(drawerKey: drawerKey),
                child: _buildHomeBody(textTheme, base, tasks)),
          );
        });
  }

  Widget _buildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [
        // custome app bar
        Container(
            margin: const EdgeInsets.only(top: 40.0),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.primaryColor,
                    ),
                  ),
                ),

                // space
                25.w,

                // Top level task info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text("${checkDoneTask(tasks)} of ${tasks.length} tasks", style: textTheme.titleMedium)
                  ],
                )
              ],
            )),

        // divider
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            indent: 100,
          ),
        ),

        // tasks
        SizedBox(
          width: double.infinity,
          height: 425, // 745
          child: tasks.isNotEmpty
              ? ListView.builder(
                  itemCount: tasks.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var task = tasks[index];

                    return Dismissible(
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          // remove task from DB
                          base.dataStore.deleteTask(task: task);
                        },
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.deblur_outlined,
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
                          task: task,
                        ));
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeIn(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(lottieURL,
                            animate: tasks.isNotEmpty ? false : true),
                      ),
                    ),
                    FadeInUp(
                      from: 30,
                      child: const Text(
                        AppStr.doneAllTask,
                      ),
                    ),
                  ],
                ),
        )
      ]),
    );
  }
}
