import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/utils/auth.dart';
import 'package:turn_me_on/ui/screens/profilesetup.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<List<String>> getFriends() async {

    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('friends') &&
        querySnapshot.data['friends'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['friends']);
    }
    return [];
  }

  // TODO
  Future<List<String>> getTasks(String listID) async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('ToDoLists')
        .document(listID)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('tasks') &&
        querySnapshot.data['tasks'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['tasks']);
    }
    return [];
  }

  Future<int> getPoints() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('points'))  {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['points'];
    }
    return 0;
  }




  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }

  Future<String> getBirthday() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('birthday')) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['birthday'];
    }
    return "";
  }

  Future<String> getLikes() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('likes')) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['likes'];
    }
    return "";
  }

  Future<String> getHappyImage() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('happyImage')) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['happyImage'];
    }
    return "";
  }

  Future<String> getSadImage() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('sadImage')) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['sadImage'];
    }
    return "";
  }

  Future<String> getNeutralImage() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('neutralImage')) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['neutralImage'];
    }
    return "";
  }

  Future<String> getVeryHappyImage() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('veryHappyImage')) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['veryHappyImage'];
    }
    return "";
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    state.user = firebaseUser;

    if (firebaseUser != null) {

      final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        state.newuser = true;
//        Firestore.instance.collection('users').document(firebaseUser.uid).setData(
//            {'id': firebaseUser.uid, 'username': firebaseUser.displayName, 'photoUrl': firebaseUser.photoUrl});
      }

      //List<String> favorites = await getFavorites();
      String bday = await getBirthday();
      String likes = await getLikes();
      List<String> friends = await getFriends();
      String happy = await getHappyImage();
      String sad = await getSadImage();
      String neutral = await getNeutralImage();
      String veryHappy = await getVeryHappyImage();
      int points = await getPoints();
      setState(() {
        state.isLoading = false;
        //state.favorites = favorites;
        state.birthday = bday;
        state.likes = likes;
        state.friends = friends;
        state.happyUrl = happy;
        state.sadUrl = sad;
        state.neutralUrl = neutral;
        state.veryHappyUrl = veryHappy;
        state.points = points;

      });
    }

  }

  Future<Null> signOutOfGoogle() async {
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state.user = null;
    setState(() {
      state = StateModel(user: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}