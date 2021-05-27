import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

class TaskItem {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
  });
}

class Tasks with ChangeNotifier {
  final String? authToken;

  Tasks(this.authToken, this._tasks);

  List<TaskItem> _tasks = [];

  List<TaskItem> get tasks {
    return [..._tasks];
  }

  Future<void> fetchAndSetTasks() async {
    final url = Uri.parse(
        'https://goal-achiever-171150-default-rtdb.firebaseio.com/tasks.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<TaskItem> loadedTasks = [];
      extractedData.forEach((prodId, prodData) {
        loadedTasks.add(TaskItem(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          date: prodData['date'],
          isDone: prodData['isDone'],
        ));
      });
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTask(TaskItem newTask) async {
    final url = Uri.parse(
        'https://goal-achiever-171150-default-rtdb.firebaseio.com/tasks.json?auth=$authToken');
    final response = await http.post(
      url,
      body: json.encode({
        'id': newTask.id,
        'title': newTask.title,
        'description': newTask.description,
        'date': newTask.date.toString(),
        'isDone': newTask.isDone,
      }),
    );
    _tasks.add(newTask);
    print(response.body);
    notifyListeners();
  }
}
