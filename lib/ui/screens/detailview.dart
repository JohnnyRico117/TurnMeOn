import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turn_me_on/model/recipe.dart';
import 'package:turn_me_on/ui/widgets/recipe_title.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';
import 'package:turn_me_on/utils/store.dart';
import 'package:turn_me_on/ui/widgets/recipe_image.dart';
import 'package:turn_me_on/ui/screens/assigntask.dart';

class DetailScreen extends StatefulWidget {
  //final Recipe recipe;
  //final bool inFavorites;

  final DocumentSnapshot snap;

  DetailScreen(this.snap);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
  StateModel appState;

  String _giverName;

  bool _tapped;
  bool _pointTapped;

  FocusNode _focusNode;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    //_inFavorites = widget.inFavorites;

    _giverName = null;

    _tapped = false;
    _pointTapped = false;

    _focusNode = FocusNode();

    setGiverName();

  }

  Future<void> setGiverName() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(widget.snap.data['Giver'])
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('username')) {

      if(this.mounted) {
        setState(() {
          _giverName = querySnapshot.data['username'];
        });
      }
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      _inFavorites = !_inFavorites;
    });
  }

  Widget _prizeText() {

    print(_tapped.toString());

    return
      _tapped == false ?
        GestureDetector(
          child: Row(
            children: <Widget>[
              Text("1000", style: _biggerFont),
              Icon(
                Icons.attach_money,
                color: Colors.green,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _pointTapped = false;
              _tapped = true;
            });
          }
        ) :
        Container(
          width: 150.0,
          child: TextField(
            autofocus: true,
            decoration: new InputDecoration(
                hintText: 'Enter prize...',
                contentPadding: const EdgeInsets.all(16.0)
            ),
            onSubmitted: (val) {
//              widget.snap.reference.updateData({
//
//              });
              setState(() {
                _tapped = false;
              });
            },
            focusNode: _focusNode,
          )
        );
  }

  Widget _pointsText() {

    return
      _pointTapped == false ?
      GestureDetector(
          child: Row(
            children: <Widget>[
              Text(widget.snap.data['Points'].toString(), style: _biggerFont),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _tapped = false;
              _pointTapped = true;
            });
          }
      ) :
      Container(
          width: 150.0,
          child: TextField(
            autofocus: true,
            decoration: new InputDecoration(
                hintText: 'Enter points...',
                contentPadding: const EdgeInsets.all(16.0)
            ),
            onSubmitted: (val) {
              widget.snap.reference.updateData({
                'Points': int.parse(val),

              });
              setState(() {
                _pointTapped = false;
              });
            },

            focusNode: _focusNode,
          )
      );
  }





  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    //setGiverName();

    return GestureDetector(
      child: Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Text("Picture"),
                    //Text("Title")


                    //AssetImage("assets/brooke-lark-385507-unsplash.jpg"),
                    RecipeImage("https://images.pexels.com/photos/17796/christmas-xmas-gifts-presents.jpg?cs=srgb&dl=birthday-christmas-gift-17796.jpg&fm=jpg"),
                    RecipeTitle(widget.snap, 25.0),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Text('Description: ', style: _biggerFont),
                          Text("Enter a description....", style: _biggerFont),

                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Text('Prize: ', style: _biggerFont),
                          _prizeText(),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Text('Points: ', style: _biggerFont),
                          _pointsText()
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Text('Assigned to: ', style: _biggerFont),
                          GestureDetector(
                            child:
                              _giverName == null ? Text("Not Assigned", style: _biggerFont) :
                              Text(_giverName, style: _biggerFont),
                            onTap: () {
                              setState(()  {
                                _tapped = false;
                                _pointTapped = false;
                              });

                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => AssignTask(widget.snap)),
                              ).then((newGiver) {
                                  setState(() {
                                    _giverName = newGiver;
                                  });
                              });
                            },
                          )
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Text('Status: ', style: _biggerFont),
                          Text(widget.snap.data['Done'] == true ? "Done" : "Not Done", style: _biggerFont)
                        ],
                      ),
                    ),
                    //Padding(),

                  ],
                ),
              ),
              expandedHeight: 580.0,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
//              bottom: TabBar(
//                tabs: <Widget>[
//                  Tab(text: "Home"),
//                  Tab(text: "Preparation"),
//                ],
//                controller: _tabController,
//              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            //IngredientsView(widget.recipe.ingredients),
            //PreparationView(widget.recipe.preparation),
          ],
          controller: _tabController,
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          updateFavorites(appState.user.uid, widget.recipe.id).then((result) {
//            // Toggle "in favorites" if the result was successful.
//            if (result) _toggleInFavorites();
//          });
//        },
//        child: Icon(
//          _inFavorites ? Icons.favorite : Icons.favorite_border,
//          color: Theme.of(context).iconTheme.color,
//        ),
//        elevation: 2.0,
//        backgroundColor: Colors.white,
//      ),
    ),
      onTap: () {
        print("1");
        FocusScope.of(context).requestFocus(_focusNode);
        setState(() {
          _tapped = false;
          _pointTapped = false;
        });
      }
    );
  }
}