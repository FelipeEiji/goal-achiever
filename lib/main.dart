import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:goal_achiever/providers/auth.dart';
import 'package:goal_achiever/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'GoalAchiever',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          fontFamily: 'Lato',
        ),
        home: LoginScreen(),
      ),
    );
  }
}
