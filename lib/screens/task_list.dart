import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'package:goal_achiever/providers/tasks.dart';
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
    await Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
  }

  Future<void> _deleteTask(BuildContext context, String id) async {
    await Provider.of<Tasks>(context, listen: false).deletaTask(id);
  }

  Future<void> _changeTaskDoneStatus(
      BuildContext context, TaskItem task) async {
    await Provider.of<Tasks>(context, listen: false)
        .updateProduct(task.id, task);
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
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  child: Card(
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            value: tasks.tasks[index].isDone,
                            onChanged: (value) {
                              tasks.tasks[index].isDone =
                                  !tasks.tasks[index].isDone;
                              _changeTaskDoneStatus(
                                  context, tasks.tasks[index]);
                            },
                          ),
                        ),
                        Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tasks.tasks[index].title),
                                Text(
                                  formatDate(tasks.tasks[index].date, [
                                    M,
                                    ' ',
                                    dd,
                                    ',',
                                    yyyy,
                                    ' ',
                                  ]),
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () =>
                                _deleteTask(context, tasks.tasks[index].id),
                            icon: Icon(Icons.delete),
                          ),
                        )
                      ],
                    ),
                  ));
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
