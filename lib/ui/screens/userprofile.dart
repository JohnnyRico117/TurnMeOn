import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('User Profile')
        ),
        body: Column(

          children: [

          ],

        )
    );
  }


  Widget _buildAvatar() {
    return new Hero(
      child: new CircleAvatar(
        //backgroundImage: new NetworkImage(widget.state.userPic),
        radius: 50.0,
      ),
    );
  }
}