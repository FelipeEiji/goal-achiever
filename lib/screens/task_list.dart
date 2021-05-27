import 'package:flutter/material.dart';

import 'package:goal_achiever/providers/task.dart';
import 'package:goal_achiever/widgets/hamburger_menu.dart';
import 'package:goal_achiever/widgets/new_task.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _addNewTask(
      BuildContext ctx, String title, String description, DateTime date) {
    final tasks = Provider.of<Tasks>(context, listen: false);
    final newTask = TaskItem(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      date: date,
      isDone: false,
    );

    setState(() {
      tasks.addTask(newTask);
    });
  }

  void startAddNewTask(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: NewTask(_addNewTask),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  Future<void> _refreshTasks(BuildContext context) async {
    await Provider.of<Tasks>(context).fetchAndSetTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoalAchiever'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => startAddNewTask(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshTasks(context),
        child: Consumer<Tasks>(
          builder: (context, tasks, child) => ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: tasks.tasks.length,
            itemBuilder: (BuildContext ccontext, int index) {
              return Container(
                height: 50,
                child: Center(
                  child: Text(tasks.tasks[index].title),
                ),
              );
            },
          ),
        ),
      ),
      drawer: HamburgerMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTask(context),
      ),
    );
  }
}
