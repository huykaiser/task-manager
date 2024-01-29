import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/data/hive_data_store.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/views/home/home_view.dart';
import 'package:task_manager/views/tasks/task_view.dart';

Future<void> main() async {
  // init hive db
  await Hive.initFlutter();

  // register hive adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  // open a box
  Box box = await Hive.openBox<Task>(HiveDataStore.boxName);

  // this is step is not necessary
  // delete data from previous day
  box.values.forEach((task) {
    if(task.createdAtTime.day != DateTime.now().day){
      task.delete();
    }else{
      // do nothing
    }
  });

  runApp(BaseWidget(child: const MyApp()));
}

// the inherited widget provides us with a convenient way
// to pass data between widgets. While developing an app
// you will need some data from your parent's widgets or
// grand parent widgets or maybe beyond that.
class BaseWidget extends InheritedWidget{
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);

  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context){
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    
    if(base!=null){
      return base;
    }else{
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive Todo App',
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          headline3: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headline4: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headline5: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          subtitle2: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          headline6: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: const HomeView(),
    );
  }
}
