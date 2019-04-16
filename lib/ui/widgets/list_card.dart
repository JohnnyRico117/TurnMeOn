import 'package:flutter/material.dart';

import 'package:turn_me_on/model/todolist.dart';
import 'package:turn_me_on/ui/screens/tasklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListCard extends StatelessWidget {

  final ToDoList toDoList;
  final DocumentSnapshot document;

  ListCard({@required this.document,@required this.toDoList });

  @override
  Widget build(BuildContext context) {
    Padding _buildTitleSection() {
      return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          // Default value for crossAxisAlignment is CrossAxisAlignment.center.
          // We want to align title and description of recipes left:
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              toDoList.name,
              style: Theme.of(context).textTheme.title, // New code
            ),
            // Empty space:
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.timer, size: 20.0),
                SizedBox(width: 5.0),
                Text(
                  //recipe.getDurationString,
                  'SOMETHING',
                  // New code
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new TaskList(),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We overlap the image and the button by
              // creating a Stack object:
//              Stack(
//                children: <Widget>[
//                  AspectRatio(
//                    aspectRatio: 16.0 / 9.0,
//                    child: Image.network(
//                      recipe.imageURL,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
////                  Positioned(
////                    child: _buildFavoriteButton(),
////                    top: 2.0,
////                    right: 2.0,
////                  ),
//                ],
//              ),
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );

  }

}