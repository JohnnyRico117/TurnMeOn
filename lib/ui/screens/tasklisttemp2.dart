import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/recipe.dart';
import 'package:turn_me_on/model/todolist.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';
import 'package:turn_me_on/utils/store.dart';
import 'package:turn_me_on/model/task.dart';
import 'package:turn_me_on/ui/screens/addtask.dart';
import 'package:turn_me_on/ui/screens/detailview.dart';
import 'package:turn_me_on/ui/widgets/wishlist_item.dart';

class TaskListTemp2 extends StatefulWidget {
  //final Recipe recipe;
  //final bool inFavorites;

  //final ToDoList toDoList;
  //final String listID;



  @override
  _TaskListTempState createState() => _TaskListTempState();
}

class _TaskListTempState extends State<TaskListTemp2>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  //bool _inFavorites;
  StateModel appState;
  String _text = "";
  Widget _widget;


  DocumentSnapshot _snap;

  String _sortby;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);

  List _sortType = ['Alphabet', 'Date', 'Points', 'Prize'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<String> tasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    //_inFavorites = widget.inFavorites;

    _dropDownMenuItems = getDropDownMenuItems();
    _sortby = _dropDownMenuItems[0].value;

    //initTasks();

  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sort in _sortType) {
      items.add(new DropdownMenuItem(
          value: sort,
          child: new Text(sort)
      ));
    }
    return items;
  }

//  Future<Null> initTasks() async {
//
//    DocumentSnapshot snap = await Firestore.instance
//        .collection('ToDoLists')
//        .document(widget.listID)
//        .get();
//    if (snap.exists &&
//        snap.data.containsKey('tasks') &&
//        snap.data['tasks'] is List) {
//      tasks = List<String>.from(snap.data['tasks']);
//    }
//
//  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      //_inFavorites = !_inFavorites;
    });
  }






  Future<Widget> _buildWidget(DocumentReference ref) async {
    DocumentSnapshot snap = await ref.get();
    return Text(snap.data['Task']);
  }

  Future<String> _buildItem(DocumentReference ref) async {

    var test = "alt";
    DocumentSnapshot snap = await ref.get();
    test = snap.data['Task'];
    return test;


//    var test = "alt";
//    DocumentSnapshot snap = await ref.get();
//    test = snap.data['Task'];
//
////    ref.get().then((snap)  {
////      test = snap.data['Task'];
////      print(snap.data['Task']);
////      Text(snap.data['Task'].toString());
////    });
//    return Text(test);

  }




//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.toDoList.name),
//      ),
//      body: StreamBuilder(
//          stream: Firestore.instance.collection('ToDoLists').document(widget.listID).snapshots(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) return const Text('Loading....');
//            return ListView.builder(
//                padding: const EdgeInsets.all(16.0),
//                //itemExtent: 80.0,
//                itemCount: snapshot.data['tasks'].length,
//                itemBuilder: (context, i) {
//                  print(widget.listID);
//                  print(i);
////                if (i.isOdd) return Divider(); /*2*/
////
////                final index = i ~/ 2; /*3*/
////                if (index >= snapshot.data.documents.length) {
////                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
////                }
//                  //return _buildDoneItem(snapshot.data.documents[i]);
//                  //return Text(snapshot.data['tasks'][i].toString());
//
//                  //return _buildWidget(snapshot.data['tasks'][i]);
//
//                  _buildWidget(snapshot.data['tasks'][i]).then((val) => setState(() {
//                    _widget = val;
//                  }));
////                  print("JAWOHL!");
////                  //return Text(_text);
//                 return _widget;
//
//                });
//          }),
//
////        new ListView.builder(
////            padding: const EdgeInsets.all(16.0),
////            itemExtent: 80.0,
////            itemCount: widget.toDoList.tasks.length,
////            itemBuilder: (context, i) {
////
////              String text;
////
////              print(widget.toDoList.tasks[i].toString());
////
////              Firestore.instance
////                  .collection('Tasks')
////                  .document(widget.toDoList.tasks[i].toString())
////                  .snapshots()
////                  .listen((data) => print(data['Task']));
////
////
////
////
//////                final index = i ~/ 2; /*3*/
//////                if (index >= snapshot.data.documents.length) {
//////                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//////                }
////            //return _buildTodoItem(snapshot.data.documents[i]);
////              return Text("Task: ");
////        }),
//
//      floatingActionButton: new FloatingActionButton(
//          onPressed: () {
//            Navigator.push(context,
//              MaterialPageRoute(builder: (context) => AddTask(widget.listID)),
//            );
//          },
//          tooltip: 'Add task',
//          child: new Icon(Icons.add)
//      ),
//    );
//  }

//  @override
//  Widget build(BuildContext context) {
//    appState = StateWidget.of(context).state;
//
//    return Scaffold(
//      body: NestedScrollView(
//        controller: _scrollController,
//        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
//          return <Widget>[
//            SliverAppBar(
//              backgroundColor: Colors.white,
//              flexibleSpace: FlexibleSpaceBar(
//                collapseMode: CollapseMode.pin,
//                background: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    //RecipeImage(widget.recipe.imageURL),
//                    //RecipeTitle(widget.recipe, 25.0),
//                  ],
//                ),
//              ),
//              expandedHeight: 340.0,
//              pinned: true,
//              floating: true,
//              elevation: 2.0,
//              forceElevated: innerViewIsScrolled,
//              bottom: TabBar(
//                tabs: <Widget>[
//                  Tab(text: "Home"),
//                  Tab(text: "Preparation"),
//                ],
//                controller: _tabController,
//              ),
//            )
//          ];
//        },
//        body: TabBarView(
//          children: <Widget>[
//            //IngredientsView(widget.recipe.ingredients),
//            //PreparationView(widget.recipe.preparation),
//          ],
//          controller: _tabController,
//        ),
//      ),
////      floatingActionButton: FloatingActionButton(
////        onPressed: () {
////          updateFavorites(appState.user.uid, widget.recipe.id).then((result) {
////            // Toggle "in favorites" if the result was successful.
////            if (result) _toggleInFavorites();
////          });
////        },
//////        child: Icon(
//////          _inFavorites ? Icons.favorite : Icons.favorite_border,
//////          color: Theme.of(context).iconTheme.color,
//////        ),
////        elevation: 2.0,
////        backgroundColor: Colors.white,
////      ),
//    );
//  }

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

  Widget _buildTodoItem(DocumentSnapshot document) {

    //print("GIVER: " + document['Giver'].toString());


    if(document['Giver'] != null) {
      Firestore.instance.collection('users').document(document['Giver']).get().then((snap) {

        if(!mounted) {
          setState(() {
            if(snap != null) {
              _snap = snap;
            } else {
              _snap = null;
            }
            //print("OH.. SNAP:" + snap.data['username']);
          });
        }
      });
    }


    final bool alreadyDone = document['Done'];
    final int status = document['Status'];
    final int happyStatus = document['HappyStatus'];

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['Task'],
                  overflow: TextOverflow.ellipsis,
                  style: _biggerFont,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    document['Date'],
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
          Text(document['Points'].toString()),
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _simplePopup(document, happyStatus),
          new IconButton(
              icon:
                status == 1 ? Icon(Icons.check_circle_outline, color: Colors.green) :
                status == 2 ? Icon(Icons.check_circle, color: Colors.green) :
                Icon(Icons.check_circle_outline),
              onPressed: () {
                setState(() {
                  if (status == 0) {
                    document.reference.updateData({
                      'Status': 1
                    });
                    if(_snap != null) {
                      print("USERNAME: " + _snap.data['username']);
                    }
                  } else if (status == 1) {
                    document.reference.updateData({
                      'Status': 2
                    });
                    if(_snap != null) {
                      print("USERNAME: " + _snap.data['username']);
                    }
                  } else {
                    document.reference.updateData({
                      'Status': 0
                    });
                    if(_snap != null) {
                      print("USERNAME: " + _snap.data['username']);
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
          builder: (context) => new DetailScreen(document),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    //List<String> tasks =
    appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Wish-List"),
      ),



      body:
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Sort by: "),
              new DropdownButton(
                  value: _sortby,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem
              )
            ],
          ),
          Expanded(
            child: new StreamBuilder(
              stream: Firestore.instance.collection('Tasks').where("ReceiverID", isEqualTo: appState.user.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading....');
                return ListView.builder(
                    padding: const EdgeInsets.all(1.0),
                    //itemExtent: 80.0,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {

                      switch(_sortby) {
                        case 'Alphabet':
                          snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
                          break;
                        case 'Points':
                          //snapshot.data.documents.sort((a, b) => int.parse(a['Points'].toString()).compareTo(int.parse(b['Points'].toString())));
                          snapshot.data.documents.sort((a, b) => a['Points'].compareTo(b['Points']));
                          break;
                        default:
                          snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
                          break;
                      }

                      //snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
//                if (i.isOdd) return Divider(); /*2*/
//
//                final index = i ~/ 2; /*3*/
//                if (index >= snapshot.data.documents.length) {
//                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//                }
                      //return _buildTodoItem(snapshot.data.documents[i]);
                      //return Text(snapshot.data.documents[i].toString());
                      return WishListItem(snapshot.data.documents[i]);



                    });
              },
            ),
          )

        ],
      ),

      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTask()),
            );
          },
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  }

  void changedDropDownItem(String selectedSort) {
    setState(() {
      _sortby = selectedSort;
    });
  }


}