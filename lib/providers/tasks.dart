import 'dart:convert';
import 'package:goal_achiever/models/http_exception.dart';
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
          date: DateTime.parse(prodData['date']),
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
    final TaskItem newerTask = TaskItem(
      id: json.decode(response.body)['name'],
      title: newTask.title,
      description: newTask.description,
      date: newTask.date,
      isDone: newTask.isDone,
    );
    _tasks.add(newerTask);
    print(response.body);
    notifyListeners();
  }

  Future<void> updateProduct(String id, TaskItem newTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      final url = Uri.parse(
          'https://goal-achiever-171150-default-rtdb.firebaseio.com/tasks/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'id': newTask.id,
            'title': newTask.title,
            'description': newTask.description,
            'date': newTask.date.toString(),
            'isDone': newTask.isDone,
          }));
      _tasks[taskIndex] = newTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deletaTask(String id) async {
    final url = Uri.parse(
        'https://goal-achiever-171150-default-rtdb.firebaseio.com/tasks/$id.json?auth=$authToken');
    final existingTaskIndex = _tasks.indexWhere((task) => task.id == id);
    var existingTask = _tasks[existingTaskIndex];
    _tasks.removeAt(existingTaskIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _tasks.insert(existingTaskIndex, existingTask);
      notifyListeners();
      print(response.body);
      print(authToken);
      throw HttpException('Could not delete product.');
    }
  }
}
