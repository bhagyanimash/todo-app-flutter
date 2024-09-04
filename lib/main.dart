import 'package:flutter/material.dart';
import 'package:todo/components/todolist.dart';
import 'Screens/home_page.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(
        toDoList: toDoList,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
