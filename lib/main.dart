// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

import 'package:turn_me_on/app.dart';
import 'package:turn_me_on/state_widget.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new StateWidget(
  child: new TurnMeOnApp(),
));
