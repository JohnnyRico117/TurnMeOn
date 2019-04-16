import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/todolist.dart';
import 'package:turn_me_on/ui/widgets/list_card.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';

class TaskLists extends StatefulWidget {

  @override
  _TaskListsState createState() => _TaskListsState();
}

class _TaskListsState extends State<TaskLists> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Happy Lists"),
      ),
      body: _buildToDoLists(appState.user.uid),
    );
  }


  Padding _buildToDoLists(String userId) {
    CollectionReference collectionReference = Firestore.instance.collection('ToDoLists');
    Stream<QuerySnapshot> stream;
    print("USERID: " + userId);
    // The argument recipeType is set
    if (userId != null) {
      stream = collectionReference
          .where("receiverId", isEqualTo: userId)
          .snapshots();
    } else {
      // Use snapshots of all recipes if recipeType has not been passed
      stream = collectionReference.snapshots();
    }

    return Padding(
      // Padding before and after the list view:
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: new StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return _buildLoadingIndicator();
                return new ListView(
                  children: snapshot.data.documents.map((document) {
                    //return Text("TEST: " + document['name']);
                    return new ListCard(
                      toDoList: ToDoList.fromMap(document.data),
                      document: document,
                    );
                  }).toList(),
                );


//                  return new ListView(
//                    children: snapshot.data.documents
//                    // Check if the argument ids contains document ID if ids has been passed:
//                        .where((d) => ids == null || ids.contains(d.documentID))
//                        .map((document) {
//                      return new RecipeCard(
//                        recipe:
//                        Recipe.fromMap(document.data, document.documentID),
//                        inFavorites:
//                        appState.favorites.contains(document.documentID),
//                        onFavoriteButtonPressed: _handleFavoritesListChanged,
//                      );
//                    }).toList(),
//                  );
              },
            ),
          ),
          new FloatingActionButton(
              onPressed: () {
//                Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => AddList(appState.user.uid)),
//                );
              },
              tooltip: 'Add task',
              child: new Icon(Icons.add)
          ),
        ],
      ),

    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

}

