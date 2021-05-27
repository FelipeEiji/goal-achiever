import 'package:flutter/material.dart';

import 'package:goal_achiever/widgets/hamburger_menu.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoalAchiever'),
      ),
      drawer: HamburgerMenu(),
    );
  }
}
