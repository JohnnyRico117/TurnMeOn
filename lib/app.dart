import 'package:flutter/material.dart';

import 'package:turn_me_on/ui/screens/login.dart';
import 'package:turn_me_on/ui/screens/home.dart';
import 'package:turn_me_on/ui/theme.dart';
import 'package:turn_me_on/ui/screens/tasklist.dart';
import 'package:turn_me_on/ui/screens/profilesetup.dart';
import 'package:turn_me_on/ui/screens/tasklisttemp2.dart';
import 'package:turn_me_on/ui/screens/settings.dart';

class TurnMeOnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turn Me On',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/tasklist': (context) => TaskList(),
        '/temp': (context) => TaskListTemp2(),
        '/settings': (context) => Settings(),
      },
    );
  }
}