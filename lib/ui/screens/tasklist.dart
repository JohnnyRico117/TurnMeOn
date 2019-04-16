import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:turn_me_on/model/recipe.dart';
import 'package:turn_me_on/model/todolist.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';
import 'package:turn_me_on/utils/store.dart';
import 'package:turn_me_on/model/task.dart';
import 'package:turn_me_on/ui/screens/addtask.dart';

import 'package:turn_me_on/ui/widgets/task_item.dart';

class TaskList extends StatefulWidget {
  //final Recipe recipe;
  //final bool inFavorites;

//  final ToDoList toDoList;
//  final String listID;

  //TaskList(this.toDoList, this.listID);


  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  //bool _inFavorites;
  StateModel appState;
  String _text = "";
  Widget _widget;

  String _sortby;

  String _happyUrl;


  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);

  List<String> tasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    //_inFavorites = widget.inFavorites;

    //initTasks();

    //setHappyPicUrl();

    _dropDownMenuItems = getDropDownMenuItems();
    _sortby = _dropDownMenuItems[0].value;

    //_sortby =

  }

//  Future<void> setHappyPicUrl() async {
//    DocumentSnapshot querySnapshot = await Firestore.instance
//        .collection('users')
//        .document(widget.snap.data['Giver'])
//        .get();
//    if (querySnapshot.exists &&
//        querySnapshot.data.containsKey('username')) {
//
//      if(this.mounted) {
//        setState(() {
//          _giverName = querySnapshot.data['username'];
//        });
//      }
//    }
//  }

  List _sortType = ['Alphabet', 'Date', 'Points', 'Prize'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

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



  Future<List<String>> getTasks(String id) async {

    return [];

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



  Future<void> _happyPopup(BuildContext context, String url, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Good Job :)'),
          content: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/turnmeondb.appspot.com/o/JP2zcNENF5dxYC6BalhphdfIOd03%2Fhappy?alt=media&token=a953a954-d248-4d2d-8a35-5be88baa1f31",
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }


  Widget _buildTodoItem(DocumentSnapshot document) {

    //final bool alreadyDone = document['Done'];
    final int status = document['Status'];
    final int happyStatus = document['HappyStatus'];

    Firestore.instance.collection('users').document(document['ReiceiverID']).get().then((snap) {

    });

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['Task'],
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
          happyStatus == 1 ?
              IconButton(icon: new Icon(Icons.sentiment_dissatisfied, color: Colors.red),
                onPressed: () {
                  _happyPopup(context, "URL", "Really??? :(");
                },
              ) :
          happyStatus == 2 ?
          IconButton(icon: new Icon(Icons.sentiment_neutral, color: Colors.blue),
                onPressed: () {
                  _happyPopup(context, "URL", "You can do better ;)");
                },
              ) :
          happyStatus == 3 ?
          IconButton(icon: new Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
                onPressed: () {
                  _happyPopup(context, "URL", "Gooood job :)");
                },
              ) :
          happyStatus == 4 ?
          IconButton(icon: new Icon(Icons.sentiment_very_satisfied, color: Colors.green),
                onPressed: () {
                  _happyPopup(context, "URL", "You made me soooooo happy :D");
                },
              ) :
          IconButton(icon: Icon(Icons.insert_emoticon),
            onPressed: () {
              null;
            },
          ),

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
                  } else {
                    document.reference.updateData({
                      'Status': 0
                    });
                  }
                });
              }
          ),
        ],
      ),
      onTap: () {
        print("TAP");
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Do-List"),
      ),
      body: Column(
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
              //stream: Firestore.instance.collection('Tasks').where("Givers", arrayContains: "giver").snapshots(),
              stream: Firestore.instance.collection('Tasks').where("Giver", isEqualTo: appState.user.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading....');
                return ListView.builder(

                    padding: const EdgeInsets.all(16.0),
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



//                if (i.isOdd) return Divider(); /*2*/
//
//                final index = i ~/ 2; /*3*/
//                if (index >= snapshot.data.documents.length) {
//                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//                }
                      //return _buildTodoItem(snapshot.data.documents[i]);
                      //return Text(snapshot.data.documents[i].toString());

                      return TaskItem(snapshot.data.documents[i]);



                    });
              },
            ),

          ),

        ],
      ),

//      floatingActionButton: new FloatingActionButton(
//          onPressed: () {
//            Navigator.push(context,
//              MaterialPageRoute(builder: (context) => AddTask(widget.listID)),
//            );
//          },
//          tooltip: 'Add task',
//          child: new Icon(Icons.add)
//      ),
    );
  }

  void changedDropDownItem(String selectedSort) {
    setState(() {
      _sortby = selectedSort;
    });
  }


}