import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';

class TaskItem extends StatefulWidget {

  DocumentSnapshot snap;
//  String url;
//  String text;
//  int number;

  TaskItem(this.snap);

  @override
  _TaskItemState createState() => _TaskItemState();

}

class _TaskItemState extends State<TaskItem> {

  StateModel appState;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);

  String _happyImageUrl;
  String _happyText;

  Future<void> _happyPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_happyText),
          content:
            _happyImageUrl == null ?
              Image.asset("assets/No_picture_available.png",
                fit: BoxFit.contain,
              ) :
            Image.network(
              _happyImageUrl,
              fit: BoxFit.contain,
            ),
        );
      },
    );
  }

  Future<void> setHappyPic() {

    Firestore.instance.collection('users').document(widget.snap.data['ReceiverID']).get().then((snap) {
      setState(() {
        switch(widget.snap.data['HappyStatus']) {
          case 1:
            _happyImageUrl = snap.data['sadImage'];
            _happyText = "Really???";
            break;
          case 2:
            _happyImageUrl = snap.data['neutralImage'];
            _happyText = "You can do better ;)";
            break;
          case 3:
            _happyImageUrl = snap.data['happyImage'];
            _happyText = "Gooood job :)";
            break;
          case 4:
            _happyImageUrl = snap.data['veryHappyImage'];
            _happyText = "You make me soooooo happy :D";
            break;
          default:
            _happyImageUrl = null;
            break;
        }
      });
    });
  }



  //final int status = document['Status'];

  //final int happyStatus = document['HappyStatus'];

//  Firestore.instance.collection('users').document(document['ReiceiverID']).get().then((snap) {
//
//  });

  @override
  void initState() {
    setHappyPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    final int status = widget.snap.data['Status'];
    final int happyStatus = widget.snap.data['HappyStatus'];

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.snap.data['Task'],
                  //document['Task'],
                  style: _biggerFont,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.snap.data['Date'],
                    //document['Date'],
                    style: _smallerFont,
                  ),
                )

              ],

            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Text(widget.snap.data['Points'].toString()),
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          happyStatus == 1 ?
          IconButton(icon: new Icon(Icons.sentiment_dissatisfied, color: Colors.red),
            onPressed: () {
              _happyPopup(context);
            },
          ) :
          happyStatus == 2 ?
          IconButton(icon: new Icon(Icons.sentiment_neutral, color: Colors.blue),
            onPressed: () {
              _happyPopup(context);
            },
          ) :
          happyStatus == 3 ?
          IconButton(icon: new Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
            onPressed: () {
              _happyPopup(context);
            },
          ) :
          happyStatus == 4 ?
          IconButton(icon: new Icon(Icons.sentiment_very_satisfied, color: Colors.green),
            onPressed: () {
              _happyPopup(context);
            },
          ) :
          IconButton(icon: Icon(Icons.insert_emoticon),
            onPressed: () {
              null;
            },
          ),

          status == 0 ? new IconButton(
              icon: Icon(Icons.check_circle_outline),
              onPressed: () {
                setState(() {
                  widget.snap.reference.updateData({
                    'Status': 1
                  });
                });
              }) :
          status == 1 ? new IconButton(
              icon: Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: () {
                setState(() {
                  widget.snap.reference.updateData({
                    'Status': 0
                  });
                });
              }) :
          new IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green),
              onPressed: null
          )

//          new IconButton(
//              icon:
//              status == 1 ? Icon(Icons.check_circle_outline, color: Colors.green) :
//              status == 2 ? Icon(Icons.check_circle, color: Colors.green) :
//              Icon(Icons.check_circle_outline),
//              onPressed: () {
//                setState(() {
//                  if (status == 0) {
//                    widget.snap.reference.updateData({
//                      'Status': 1
//                    });
//                  } else {
//                    widget.snap.reference.updateData({
//                      'Status': 0
//                    });
//                  }
//                });
//              }
//          ),
        ],
      ),
      onTap: () {
        print("TAP");
      },
    );
  }

}


