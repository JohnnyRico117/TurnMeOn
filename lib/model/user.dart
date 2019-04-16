import 'package:turn_me_on/model/task.dart';

enum UserType {
  giver,
  receiver
}

class User {
  final String id;
  final String name;
  final UserType type;
  final int points;
  final List<String> todolists;
  //final List<String> givers;
  //final List<String> receivers;
  //final List<Task> tasks;
  //final List<String> happyImages;

  const User({
    this.id,
    this.name,
    this.type,
    this.points,
    this.todolists,
    //this.givers,
    //this.receivers,
    //this.tasks,
    //this.happyImages
  });

  User.fromMap(Map<String, dynamic> data, String id)
      : this(
          id: id,
          name: data['name'],
          type: UserType.values[data['type']],
          points: data['points'],
          todolists: new List<String>.from(data['todolists']),
          //happyImages: new List<String>.from(data['happyImages'])
  );
}