import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StateModel {
  bool isLoading;
  FirebaseUser user;
  List<String> favorites;
  bool newuser;
  List<DocumentSnapshot> snaps;
  List<String> friends;

  String happyUrl;
  String sadUrl;
  String veryHappyUrl;
  String neutralUrl;

  int points;

  DocumentReference ref;

  // User Info
  bool status;
  String birthday;
  String likes;

  StateModel({
    this.isLoading = false,
    this.newuser = false,
    this.user
  });
}