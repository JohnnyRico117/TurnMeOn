class Task {
  //final String id;
  final String task;
  final bool done;
  final DateTime date;
  final int points;
  final String receiverID;
  final String listID;

  const Task({
    //this.id,
    this.task,
    this.done,
    this.date,
    this.points,
    this.receiverID,
    this.listID

  });

  Task.fromMap(Map<String, dynamic> data)
      : this(
          //id: id,
          task: data['task'],
          done: data['done'],
          date: data['date'],
          points: data['points'],
          receiverID: data['receiverID'],
          listID: data['listID']
  );



}