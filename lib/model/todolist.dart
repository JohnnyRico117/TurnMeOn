import 'package:turn_me_on/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoList {
  //final String id;
  final String name;
  final String receiverId;
  final List<String> givers;
  final List<String> tasks;



  const ToDoList({
    //this.id,
    this.name,
    this.receiverId,
    this.givers,
    this.tasks,
  });

  ToDoList.fromMap(Map<String, dynamic> data)
      : this(
          //id: id,
          name: data['name'],
          receiverId: data['receiverId'],
          givers: data['givers'] == null ? new List<String>() : new List<String>.from(data['givers']),
          tasks: data['tasks'] == null ? new List<String>() : new List<String>.from(data['tasks']),
  );

}