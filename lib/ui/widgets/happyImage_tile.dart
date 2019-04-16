import 'dart:io';

import 'package:flutter/material.dart';
import 'package:turn_me_on/model/state.dart';
import 'package:turn_me_on/state_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class HappyImageTile extends StatefulWidget {

  String url;
  String name;
  String path;
  String dbPath;

  HappyImageTile(this.url, this.name, this.path, this.dbPath);

  @override
  State<StatefulWidget> createState() => new _HappyImageTileState();
}

class _HappyImageTileState extends State<HappyImageTile> {

  StateModel appState;

  File _image;
  String _imageUrl;

  bool _available = false;

  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      _imageUrl = widget.url;
      _available = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;
    //print("TEST" + _imageUrl);
    return ListTile(
      leading:
        _available == true ?
          Image.network(
            _imageUrl,
            fit: BoxFit.contain,
            height: 50.0,
            width: 50.0,
          ) :
        Image.asset("assets/No_picture_available.png",
          fit: BoxFit.contain,
          height: 50.0,
          width: 50.0,
        ),
        //AssetImage(),
//        DecorationImage(
//          image: AssetImage("assets/No_picture_available.png"),
//          fit: BoxFit.contain,
//        ),
      title: Text(widget.name),
      trailing: GestureDetector(
        child: Icon(Icons.add_a_photo),
        onTap: () {
          uploadPic(_image, widget.path).then((val) => {
            setState(() {
              _imageUrl = val;
            }),
            Firestore.instance.collection('users').document(appState.user.uid).updateData({
              widget.dbPath: val
            })
          });
        },
      )
    );
  }

  Future<dynamic> uploadPic(File pic, String path) async {

    File file = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 800.0);

    StorageReference reference = _storage.ref().child(appState.user.uid + "/$path/");
    StorageUploadTask uploadTask = reference.putFile(file);

    Future<dynamic> uri = (await uploadTask.onComplete).ref.getDownloadURL();

    return uri;
  }
}