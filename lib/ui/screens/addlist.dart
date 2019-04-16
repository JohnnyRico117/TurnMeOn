import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/task.dart';

class AddList extends StatelessWidget {

  final String userid;

  AddList(this.userid);

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Add a new Happy item')
        ),

        body: new TextField(

          autofocus: true,
          onSubmitted: (listname) {
            Firestore.instance.collection('ToDoLists').document()
                .setData({
                  'name': listname,
                  'receiverId': userid,
                  'givers': new List<String>(),
                  'tasks': new List<String>()
            });
            Navigator.pop(context);
          },
          decoration: new InputDecoration(
              hintText: 'Enter something to do...',
              contentPadding: const EdgeInsets.all(16.0)
          ),
        )
    );
  }
}