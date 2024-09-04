import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ToDoList extends StatefulWidget {
  ToDoList({Key? key});

  @override
  State<ToDoList> createState() => _ToDoListState();
  List toDoItem = [];

  void addTask(String text) {
    toDoItem.add([text, false]);
  }
}

ToDoList toDoList = ToDoList();

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  void Save() {
    _saveToDoList();
  }

  Future<void> _loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedListString = prefs.getString('toDoItem');
    if (savedListString != null) {
      setState(() {
        toDoList.toDoItem = _decodeToDoList(savedListString);
      });
    }
  }

  List<List<dynamic>> _decodeToDoList(String savedListString) {
    List<List<dynamic>> decodedList = [];
    List<String> splitList = savedListString.split(';');
    for (var item in splitList) {
      List<String> values = item.split(',');
      if (values.length == 2) {
        decodedList.add([values[0], values[1] == 'true']);
      }
    }
    return decodedList;
  }

  String _encodeToDoList() {
    return toDoList.toDoItem.map((item) => '${item[0]},${item[1]}').join(';');
  }

  Future<void> _saveToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList = _encodeToDoList();
    await prefs.setString('toDoItem', encodedList);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: toDoList.toDoItem.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: toDoList.toDoItem[index][1] ? Colors.greenAccent : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              leading: Checkbox(
                value: toDoList.toDoItem[index][1],
                onChanged: (bool? value) {
                  setState(() {
                    toDoList.toDoItem[index][1] = value ?? false;
                    _saveToDoList();
                  });
                },
              ),
              contentPadding: const EdgeInsets.all(8),
              title: Text(
                toDoList.toDoItem[index][0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    toDoList.toDoItem.removeAt(index);
                    _saveToDoList();
                  });
                },
              ),
            ),
          );
        });
  }
}
