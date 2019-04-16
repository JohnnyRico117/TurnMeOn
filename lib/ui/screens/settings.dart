import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/ui/widgets/settings_button.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';
import 'package:turn_me_on/ui/widgets/happyImage_tile.dart';
import 'package:turn_me_on/ui/widgets/reward_tile.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //TODO: wenn Hier Sign out, dann wie Fkt: _buildContent in home.dart
//          SettingsButton(
//            Icons.exit_to_app,
//            "Log out",
//            appState.user.displayName,
//                () async {
//              await StateWidget.of(context).signOutOfGoogle();
//            },
//          ),
          ExpansionTile(
            title: Text("My Expressions"),
            children: <Widget>[

              HappyImageTile(appState.veryHappyUrl, "Very Happy", "veryhappy", "veryHappyImage"),
              HappyImageTile(appState.happyUrl, "Happy", "happy", "happyImage"),
              HappyImageTile(appState.neutralUrl, "Neutral", "neutral", "neutralImage"),
              HappyImageTile(appState.sadUrl, "Sad", "sad", "sadImage"),


            ],
          ),
          ExpansionTile(
            title: Text("My Reward System"),
            children: <Widget>[
              RewardTile(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  FloatingActionButton(


                    onPressed: null,
                    child: Icon(Icons.add),
                  )
                ],
              )

            ],
          ),



        ],
      ),
    );
  }
}