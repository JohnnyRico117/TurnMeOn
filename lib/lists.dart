import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Lists extends StatefulWidget {
  @override
  ListsState createState() => new ListsState();
}

class ListsState extends State<Lists> {

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildDoneItem(DocumentSnapshot document) {

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.documentID,
                  style: _biggerFont,
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          //Text(document['Points']),
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
        stream: Firestore.instance.collection('Users').document('Testid').collection('Lists').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading....');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, i) {
              print("TEST");
              return _buildDoneItem(snapshot.data.documents[i]);
            });
      })



    );
  }
}