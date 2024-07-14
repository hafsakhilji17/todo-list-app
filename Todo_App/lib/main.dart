import 'package:aicp_internship_projects/data/hive_data_store.dart';
import 'package:aicp_internship_projects/models/task.dart';
import 'package:aicp_internship_projects/views/home/widgets/home_view.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//
//  Future <void> main() async{
//
//    //init hive db before runapp
//    await Hive.initFlutter();
//
//    //Register hive adapter
//    Hive.registerAdapter<Task>(TaskAdapter());
//
//    //Open a box
//    Box box = await Hive.openBox<Task>(HiveDataStore.boxName);
//    box.values.forEach((task){
//
//
//      if(task.createdAtTime.day!=DateTime.now().day){
//        task.delete();
//      }else{
//
//      }
//    });
//
//   runApp(const MyApp());
// }
//
// class BaseWidget extends InheritedWidget{
//    BaseWidget({Key?key, required this.child}): super(key: key, child: child);
//    final HiveDataStore dataStore = HiveDataStore();
//    final Widget child;
//    static BaseWidget of(BuildContext context){
//      final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
//      if(base !=null){
//        return base;
//    }else{
//        throw StateError('Could not find ancestor widget of type BaseWidget');
//      }
//
//    }
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//
//    return false;
//   }
//
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Hive Todo App',
//       theme: ThemeData(
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(
//             color: Colors.black,
//             fontSize: 45,
//             fontWeight: FontWeight.bold,
//           ),
//           titleMedium: TextStyle(
//             color: Colors.grey,
//             fontSize: 16,
//             fontWeight: FontWeight.w300,
//           ),
//           displayMedium: TextStyle(
//             color: Colors.white,
//             fontSize: 21,
//           ),
//           displaySmall: TextStyle(
//             color: Color.fromARGB(255, 234, 234, 234),
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//           ),
//           headlineMedium: TextStyle(
//             color: Colors.grey,
//             fontSize: 17,
//           ),
//           headlineSmall: TextStyle(
//             color: Colors.grey,
//             fontSize: 16,
//           ),
//           titleSmall: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//           ),
//           titleLarge: TextStyle(
//             fontSize: 40,
//             color: Colors.black,
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       home: HomeView(),
//     );
//   }
// }



Future<void> main() async {
  /// Initial Hive DB
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  /// Open box
  var box = await Hive.openBox<Task>("tasksBox");

  /// Delete data from previous day
  // ignore: avoid_function_literals_in_foreach_calls
  box.values.forEach((task) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    } else {}
  });

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
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
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          displaySmall: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headlineSmall: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
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