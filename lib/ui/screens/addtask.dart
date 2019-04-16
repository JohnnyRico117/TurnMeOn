import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';

class AddTask extends StatefulWidget {

  @override
  _AddTaskState createState() => _AddTaskState();

}

class _AddTaskState extends State<AddTask> {

  StateModel appState;

  String _task;
  String _date;
  String _points;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Add a new Happy item')
        ),
        body: new ListView(

          children: <Widget>[
            new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  hintText: 'Enter something to do...',
                  contentPadding: const EdgeInsets.all(16.0)
              ),
              //onChanged: (one) => _one = one,
              onChanged: (val) {
                setState(() {
                  _task = val;
                });
              },
            ),
            new TextField(
              decoration: new InputDecoration(
                  hintText: 'Enter deadline...',
                  contentPadding: const EdgeInsets.all(16.0)
              ),
              //onChanged: (two) => _two = two,
              onChanged: (val) {
                setState(() {
                  _date = val;
                });
              },

            ),
            new TextField(
              decoration: new InputDecoration(
                  hintText: 'Enter points...',
                  contentPadding: const EdgeInsets.all(16.0)
              ),
              onChanged: (val) {
                setState(() {
                  _points = val;
                });
              },
            ),
            RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                DocumentReference docRef = Firestore.instance.collection('Tasks').document();
                docRef.setData({
                  'Task' : _task,
                  'Done': false,
                  'Date': _date,
                  'Points': int.parse(_points),
                  'ReceiverID': appState.user.uid,
                  'Status': 0,
                  'HappyStatus': 0
                });

                print("ID: " + docRef.documentID.toString());

                Navigator.pop(context);

              },
            )
          ],

        )
//        body: new TextField(
//          autofocus: true,
//          onSubmitted: (val) {
//            Firestore.instance.collection('Todos').document().setData({ 'Task' : val, 'Done': false});
//            //_addTodoItem(val);
//            Navigator.pop(context);
//          },
//          decoration: new InputDecoration(
//              hintText: 'Enter something to do...',
//              contentPadding: const EdgeInsets.all(16.0)
//          ),
//        )
    );
  }
}

