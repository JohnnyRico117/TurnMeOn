import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:turn_me_on/model/recipe.dart';
import 'package:turn_me_on/model/todolist.dart';
import 'package:turn_me_on/utils/store.dart';
import 'package:turn_me_on/ui/widgets/recipe_card.dart';
import 'package:turn_me_on/ui/widgets/list_card.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';
import 'package:turn_me_on/ui/screens/login.dart';
import 'package:turn_me_on/ui/screens/addlist.dart';
import 'package:turn_me_on/ui/widgets/settings_button.dart';
import 'package:turn_me_on/ui/screens/profilesetup.dart';
import 'package:turn_me_on/ui/screens/tasklists.dart';
import 'package:turn_me_on/ui/screens/addfriend.dart';

import 'package:image_picker/image_picker.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel appState;

  File _image;

  FirebaseStorage _storage = FirebaseStorage.instance;


  DefaultTabController _buildTabView({Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.home, size: _iconSize)),
                Tab(icon: Icon(Icons.group, size: _iconSize)),
                Tab(icon: Icon(Icons.chat, size: _iconSize)),
                Tab(icon: Icon(Icons.lightbulb_outline, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize)),

                //Tab(icon: Icon(Icons.settings, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: body,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
    } else if (appState.newuser == true) {
      return new ProfileSetUp();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  TabBarView _buildTabsContent() {
    Padding _buildRecipes({RecipeType recipeType, List<String> ids}) {
      CollectionReference collectionReference =
      Firestore.instance.collection('recipes');
      Stream<QuerySnapshot> stream;
      // The argument recipeType is set
      if (recipeType != null) {
        stream = collectionReference
            .where("type", isEqualTo: recipeType.index)
            .snapshots();
      } else {
        // Use snapshots of all recipes if recipeType has not been passed
        stream = collectionReference.snapshots();
      }

      // Define query depeneding on passed args
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
                    children: snapshot.data.documents
                    // Check if the argument ids contains document ID if ids has been passed:
                        .where((d) => ids == null || ids.contains(d.documentID))
                        .map((document) {
                      return new RecipeCard(
                        recipe:
                        Recipe.fromMap(document.data, document.documentID),
                        inFavorites:
                        appState.favorites.contains(document.documentID),
                        onFavoriteButtonPressed: _handleFavoritesListChanged,
                      );
                    }).toList(),
                  );
                },
              ),

            ),

          ],
        ),
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
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddList(appState.user.uid)),
                );
              },
              tooltip: 'Add task',
              child: new Icon(Icons.add)
            ),
          ],
        ),

      );
    }



    return TabBarView(
      children: [
        //_buildRecipes(recipeType: RecipeType.food),
        //_buildRecipes(recipeType: RecipeType.drink),
        //_buildRecipes(ids: appState.favorites),
        //Center(child: Icon(Icons.settings)),

        _buildProfile(),
        _buildFriendsList(),

        Center(child: Icon(Icons.chat)),
        //_buildToDoLists(appState.user.uid),
        //Center(child: Icon(Icons.home)),
        _buildCameraButton(),
        //_buildToDoLists(appState.user.uid),
        _buildSettings(),
        //Center(child: Icon(Icons.settings)),7

      ],
    );
  }

  // Inactive widgets are going to call this method to
  // signalize the parent widget HomeScreen to refresh the list view:
  void _handleFavoritesListChanged(String recipeID) {
    updateFavorites(appState.user.uid, recipeID).then((result) {
      // Update the state:
      if (result == true) {
        setState(() {
          if (!appState.favorites.contains(recipeID))
            appState.favorites.add(recipeID);
          else
            appState.favorites.remove(recipeID);
        });
      }
    });
  }

  Column _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsButton(
          Icons.exit_to_app,
          "Log out",
          appState.user.displayName,
              () async {
            await StateWidget.of(context).signOutOfGoogle();
          },
        ),
      ],
    );
  }

  Widget _buildAvatar() {

    return
      new CircleAvatar(
        backgroundImage: new NetworkImage(appState.user.photoUrl),
        radius: 50.0,
      );

  }

  Widget _buildUserInfo() {
    return new Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Text(
                    appState.user.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    )
                  )
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.cake, color: Colors.pinkAccent),
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(appState.birthday)
                      )

                    ],
                  )
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.star, color: Colors.yellow),
                      Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(appState.points.toString())
                      )
                    ],
                  ),
                ),
                Container(
                    child: Text(appState.likes)
                ),

              ],
            )
          )
        ],
      )
    );

  }

  Widget _buildCards(String title, IconData icon, String route) {
    Card _buildCard() {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 1.0),
              leading: Icon(icon, color: Colors.white),
//            leading: Container(
//              height: 5.0,
//              //padding: EdgeInsets.only(right: 0.0),
////              decoration: new BoxDecoration(
////                  border: new Border(
////                      right: new BorderSide(width: 1.0, color: Colors.white24))),
//              child: Icon(Icons.sentiment_very_satisfied, color: Colors.white),
//            ),
              title: Text(
                title,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

//            subtitle: Row(
//              children: <Widget>[
//                Icon(Icons.linear_scale, color: Colors.yellowAccent),
//                Text(" Intermediate", style: TextStyle(color: Colors.white))
//              ],
//            ),
              trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
          ),
        ),
      );
    }

    return GestureDetector(
//      onTap: () => Navigator.push(
//        context,
//        MaterialPageRoute(
//
//          //builder: (context) => new TaskList(toDoList, document.documentID),
//          //builder: (context) => _buildToDoLists(appState.user.uid),
//          builder: (context) => new TaskLists(),
//        ),
//      ),
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
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
              _buildCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return new Stack(
      children: <Widget>[
        //_buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildUserInfo(),
              _buildCards("My Wish-List", Icons.sentiment_very_satisfied, '/temp'),
              _buildCards("My To-Do-List", Icons.sentiment_very_satisfied, '/tasklist'),
              _buildCards("Settings", Icons.settings, '/settings')
              //_buildFollowerInfo(textTheme),
              //_buildActionButtons(theme),
            ],
          ),
        ),
//        new Positioned(
//          top: 26.0,
//          left: 4.0,
//          child: new BackButton(color: Colors.red),
//        ),
      ],
    );
  }

  Widget _buildCameraButton() {

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: getImage,
        onPressed: uploadPic,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future<StorageReference> uploadPic() async {

    File file = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = file;
    });

    StorageReference reference = _storage.ref().child(appState.user.uid + "/images/");

    StorageUploadTask uploadTask = reference.putFile(file);

    print("LOC" + uploadTask.toString());

    StorageReference ref = (await uploadTask.onComplete).ref;

    ref.getPath().then((val) => {
      print(val),
    });

    return reference;
  }




  Padding _buildFriendsList() {

      // Define query depeneding on passed args
      return Padding(
        // Padding before and after the list view:
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: new StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _buildLoadingIndicator();
                  return new ListView(
                    children: snapshot.data.documents
                    // Check if the argument ids contains document ID if ids has been passed:
                        .where((d) => appState.friends == null || appState.friends.contains(d.documentID))
                        .map((document) {
//                      return new RecipeCard(
//                        recipe:
//                        Recipe.fromMap(document.data, document.documentID),
//                        inFavorites:
//                        appState.favorites.contains(document.documentID),
//                        onFavoriteButtonPressed: _handleFavoritesListChanged,
//                      );
                      return _buildFriend(document);
                        //return Text("TEST");
                    }).toList(),
                  );
                },
              ),
            ),
            ListTile(


              leading: new FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriend()),
                    );
                  },
                  child: Icon(Icons.add)
              ),
              title: new Text("Add Friend"),
            ),
//            ListTile(
//              leading: new FloatingActionButton(
//                  onPressed: null,
//                  child: Icon(Icons.add)
//              ),
//              title: new Text("Invite Contact"),
//            ),

          ],
        ),
      );

  }

  Widget _buildFriend(DocumentSnapshot document) {
    return ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage(document['userpic']),
        radius: 30.0,
      ),
      title: new Text(document['username']),

    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}