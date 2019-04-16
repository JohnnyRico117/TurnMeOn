import 'package:flutter/material.dart';

class RewardTile extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _RewardTileState();

}

class _RewardTileState extends State<RewardTile> {


  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.yellow),
          Text("10"),
          Text("   One kiss")
        ],
      ),
      trailing: Icon(Icons.edit),
    );
  }


}