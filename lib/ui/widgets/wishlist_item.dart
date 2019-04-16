import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';

import 'package:turn_me_on/ui/screens/detailview.dart';

class WishListItem extends StatefulWidget {

  DocumentSnapshot snap;

  WishListItem(this.snap);

  @override
  _WishListItemState createState() => _WishListItemState();
}

class _WishListItemState extends State<WishListItem> {

  StateModel appState;

  DocumentSnapshot _giverSnap;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);

  Future<void> setGiver() {
    Firestore.instance.collection('users').document(widget.snap.data['Giver']).get().then((snap) {
      setState(() {
        _giverSnap = snap;
      });
    });
  }

  Widget _simplePopup(DocumentSnapshot snap, int happy) => PopupMenuButton<int>(
    icon:
    happy == 1 ? Icon(Icons.sentiment_dissatisfied, color: Colors.red) :
    happy == 2 ? Icon(Icons.sentiment_neutral, color: Colors.blue) :
    happy == 3 ? Icon(Icons.sentiment_satisfied, color: Colors.lightGreen) :
    happy == 4 ? Icon(Icons.sentiment_very_satisfied, color: Colors.green) :
    Icon(Icons.insert_emoticon),
    itemBuilder: (context) => [
      happy != 0 ? PopupMenuItem(
        value: 0,
        child: IconButton(icon: new Icon(Icons.insert_emoticon)),
      ) : null,
      happy != 1 ? PopupMenuItem(
        value: 1,
        child: IconButton(icon: new Icon(Icons.sentiment_dissatisfied, color: Colors.red)),
      ) : null,
      happy != 2 ? PopupMenuItem(
        value: 2,
        child: IconButton(icon: new Icon(Icons.sentiment_neutral, color: Colors.blue)),
      ) : null,
      happy != 3 ? PopupMenuItem(
        value: 3,
        child: IconButton(icon: new Icon(Icons.sentiment_satisfied, color: Colors.lightGreen)),
      ) : null,
      happy != 4 ? PopupMenuItem(
        value: 4,
        child: IconButton(icon: new Icon(Icons.sentiment_very_satisfied, color: Colors.green)),
      ) : null,
    ],
    onSelected: (value) {
      setState(() {
        snap.reference.updateData({
          'HappyStatus': value
        });
      });
    },
  );

  @override
  void initState() {
    setGiver();
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
                  overflow: TextOverflow.ellipsis,
                  style: _biggerFont,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.snap.data['Date'],
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
          _simplePopup(widget.snap, happyStatus),
          new IconButton(
              icon:
              status == 1 ? Icon(Icons.check_circle_outline, color: Colors.green) :
              status == 2 ? Icon(Icons.check_circle, color: Colors.green) :
              Icon(Icons.check_circle_outline),
              onPressed: () {
                setState(() {
                  if (status == 0) {
                    widget.snap.reference.updateData({
                      'Status': 1
                    });
                    if(_giverSnap.data != null) {
                      print("USERNAME: " + _giverSnap.data['username']);

                    }
                  } else if (status == 1) {
                    widget.snap.reference.updateData({
                      'Status': 2
                    });
                    if(_giverSnap.data != null) {
                      print("USERNAME: " + _giverSnap.data['username']);
                      _giverSnap.reference.updateData({
                        'points': _giverSnap.data['points'] + widget.snap.data['Points']
                      });
                      setGiver();
                    }
                  } else {
                    widget.snap.reference.updateData({
                      'Status': 0
                    });
                    if(_giverSnap.data != null) {
                      print("USERNAME: " + _giverSnap.data['username']);
                      _giverSnap.reference.updateData({
                        'points': _giverSnap.data['points'] - widget.snap.data['Points']
                      });
                      setGiver();
                    }
                  }
                });
              }
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new DetailScreen(widget.snap),
        ),
      ),
    );
  }

}