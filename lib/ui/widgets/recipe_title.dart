import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//import 'package:recipes_app/model/recipe.dart';

class RecipeTitle extends StatelessWidget {
  //final Recipe recipe;

  final DocumentSnapshot snap;
  final double padding;

  RecipeTitle(this.snap, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            snap.data['Task'],
            style: Theme.of(context).textTheme.title,
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                snap.data['Date'],
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}