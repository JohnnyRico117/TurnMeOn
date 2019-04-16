import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';

class AssignTask extends StatelessWidget {

  DocumentSnapshot taskSnap;

  AssignTask(this.taskSnap);

  StateModel appState;

  Padding _buildFriendsList(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: new StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return _buildLoadingIndicator();
                return new ListView(
                  children: snapshot.data.documents
                      .where((d) => appState.friends == null || appState.friends.contains(d.documentID))
                      .map((document) {
                    return _buildFriend(document, context);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriend(DocumentSnapshot document, BuildContext context) {
    return ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage(document['userpic']),
        radius: 30.0,
      ),
      title: new Text(document['username']),
      trailing: IconButton(
          icon: Icon(Icons.assignment),
          onPressed: () {
            print("UP");
            taskSnap.reference.updateData({
              'Giver': document.documentID,
            });
            Navigator.pop(context, document['username']);
          }
      )
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return new Scaffold(
      body: _buildFriendsList(context),
    );

  }



}