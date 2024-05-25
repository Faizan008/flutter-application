// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasker/screens/task_screen.dart';
import 'package:tasker/screens/login_screen.dart';
import 'package:tasker/screens/registration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task App',
      theme: ThemeData(useMaterial3: true,inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder()
      )),
      home: TaskScreen(),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegistrationScreen()),
        GetPage(name: '/home', page: () => TaskScreen()),
      ],
    );
  }
}

