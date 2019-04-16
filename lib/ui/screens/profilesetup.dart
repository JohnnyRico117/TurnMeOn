import 'dart:io';

import 'package:flutter/material.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';


class ProfileSetUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ProfileSetUpState();
}

class ProfileSetUpState extends State<ProfileSetUp> {

//  StateModel appState;
//  int _radioValue = 0;
//  bool _result = true;
//
//  void _handleRadioValueChange(int value) {
//    setState(() {
//      _radioValue = value;
//
//      switch (_radioValue) {
//        case 0:
//          _result = true;
//          break;
//        case 1:
//          _result = false;
//          break;
//    }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    appState = StateWidget.of(context).state;
//
//    return Scaffold(
//      body: Container(
//        child: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                  "Hello " + appState.user.displayName,
//                  style: new TextStyle(fontSize: 20.0)
//              ),
//
//              Text("Are you a:",
//                  style: new TextStyle(fontSize: 16.0)
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Radio(
//                    value: 0,
//                    groupValue: _radioValue,
//                    onChanged: _handleRadioValueChange,
//                  ),
//                  Text(
//                    'Happy Receiver',
//                    style: new TextStyle(fontSize: 16.0),
//                  ),
//                ]
//              ),
//              Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Radio(
//                      value: 1,
//                      groupValue: _radioValue,
//                      onChanged: _handleRadioValueChange,
//                    ),
//                    Text(
//                      'Happy Giver',
//                      style: new TextStyle(fontSize: 16.0),
//                    ),
//                  ]
//              ),
//              Text("?", style: new TextStyle(fontSize: 16.0)),
//              RaisedButton(
//                onPressed: () {
//                  Firestore.instance.collection('users').document(appState.user.uid).setData(
//                      {'id': appState.user.uid, 'username': appState.user.displayName, 'userpic': appState.user.photoUrl, 'status': _result});
//                  appState.status = _result;
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => PersonalInfo()),
//                  );
//                },
//                child:
//                  Text("Submit")
//
//              )
//            ],
//          )
//        )
//      )
//    );
//  }

  StateModel appState;
  String _birthday;
  String _likes;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
        body: Container(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("You can add some personal Infos, if you want"),
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Your birthday',
                          hintText: 'DD.MM.YYYY',
                          contentPadding: const EdgeInsets.all(16.0),
                          prefixIcon: Icon(Icons.cake),
                          prefixStyle: TextStyle(color: Colors.red)
                      ),
                      onChanged: (birthday) => _birthday = birthday,

                    ),
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'What do you like?',
                          hintText: 'Flowers, fun, food...',
                          contentPadding: const EdgeInsets.all(16.0),
                          prefixIcon: Icon(Icons.favorite),
                          prefixStyle: TextStyle(color: Colors.red)
                      ),
                      onChanged: (likes) => _likes = likes,

                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Back!'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Firestore.instance.collection('users').document(appState.user.uid).setData(
                                {'id': appState.user.uid,
                                  'username': appState.user.displayName,
                                  'userpic': appState.user.photoUrl,
                                  'birthday': _birthday,
                                  'likes': _likes,
                                  'points': 0
                                });

//                            Firestore.instance.collection('users').document(appState.user.uid).updateData(
//                                {'birthday': _birthday, 'likes': _likes});
                            appState.newuser = false;
                            appState.birthday = _birthday;
                            appState.likes = _likes;
                            //Navigator.pushReplacementNamed(context, '/');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HappyPictures()),
                            );
                          },
                          child: Text("Submit"),
                        ),
                        RaisedButton(
                            onPressed: null,
                            child: Text("Skip")
                        )
                      ],
                    )
                  ],
                )
            )
        )
    );
  }

}

class HappyPictures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HappyPicturesState();
}

class HappyPicturesState extends State<HappyPictures> {

  File _sadImage;
  File _neutralImage;
  File _happyImage;
  File _veryHappyImage;

  String _sadUri;
  String _neutralUri;
  String _happyUri;
  String _veryHappyUri;

  FirebaseStorage _storage = FirebaseStorage.instance;

  StateModel appState;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 200.0,
                      child: Center(
                        child: _sadImage == null
                            ? Text('No image selected.')
                            : Image.file(_sadImage, fit: BoxFit.cover),
                      ),
                    ),
                    onTap: () {
                      uploadPic(_sadImage, "sad").then((val) => {
                        print('PIC: ' + val),
                        _sadUri = val,
                      });
                    }

                  ),
                  GestureDetector(
                    child: Container(
                      height: 200.0,
                      child: Center(
                        child: _neutralImage == null
                            ? Text('No image selected.')
                            : Image.file(_neutralImage, fit: BoxFit.cover),

                      ),
                    ),
                    onTap: () {
                      uploadPic(_neutralImage, "neutral").then((val) => {
                        _neutralUri = val,
                      });
                    }

                  )
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 200.0,
                      child: Center(
                        child: _happyImage == null
                            ? Text('No image selected.')
                            : Image.file(_happyImage, fit: BoxFit.cover),

                      ),
                    ),
                    onTap: () {
                      uploadPic(_happyImage, "happy").then((val) => {
                      _happyUri = val,
                      });
                    }
                  ),
                  GestureDetector(
                    child: Container(
                      height: 200.0,
                      child: Center(
                        child: _veryHappyImage == null
                            ? Text('No image selected.')
                            : Image.file(_veryHappyImage, fit: BoxFit.cover),

                      ),
                    ),
                    onTap: () {
                      uploadPic(_veryHappyImage, "veryhappy").then((val) => {
                        _veryHappyUri = val,
                      });
                    }
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back!'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Firestore.instance.collection('users').document(appState.user.uid).updateData({
                        'sadImage': _sadUri,
                        'neutralImage': _neutralUri,
                        'happyImage': _happyUri,
                        'veryHappyImage': _veryHappyUri
                      });

                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text("Submit"),
                  ),
                  RaisedButton(
                      onPressed: null,
                      child: Text("Skip")
                  )
                ],
              )

            ],
          )
        )
      )
    );
  }

  Future<dynamic> uploadPic(File pic, String path) async {

    File file = await ImagePicker.pickImage(source: ImageSource.camera);

    switch(path) {
      case "sad":
        setState(() {
          _sadImage = file;
        });
        break;
      case "neutral":
        setState(() {
          _neutralImage = file;
        });
        break;
      case "happy":
        setState(() {
          _happyImage = file;
        });
        break;
      case "veryhappy":
        setState(() {
          _veryHappyImage = file;
        });
        break;
      default:
        break;
    }

    StorageReference reference = _storage.ref().child(appState.user.uid + "/$path/");

    StorageUploadTask uploadTask = reference.putFile(file);

    Future<dynamic> uri = (await uploadTask.onComplete).ref.getDownloadURL();

    return uri;
  }



}