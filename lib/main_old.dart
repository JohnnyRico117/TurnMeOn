// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turn_me_on/lists.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(TurnMeOnApp());

// Every component in Flutter is a widget, even the whole app itself
class TurnMeOnApp extends StatelessWidget {
  //const TurnMeOnApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turn Me On',
      //home: const TodoList(title: "Eva Happy List"),
      //home: TodoList(),
      home: Lists(),
    );
  }
}

class TodoListState extends State<TodoList> {

  int _selectedIndex = 1;
  //const TodoList({Key key, this.title}) : super(key: key);

  //final String title;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);

  Widget _buildTodoItem(DocumentSnapshot document) {

    final bool alreadyDone = document['Done'];
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['Task'],
                  style: _biggerFont,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    document['Date'],
                    style: _smallerFont,
                  ),
                )

              ],

            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Text(document['Points']),
        ],
      ),


      //subtitle: Text('TEST'),
      trailing: new Icon(
        //Icons.favorite,
        //color: Colors.red,
        //alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
        alreadyDone ? Icons.favorite : Icons.favorite_border,
        //color: alreadySaved ? Colors.green : null,
        color: alreadyDone ? Colors.red : null,

      ),
      onTap: () {
        setState(() {
          if (alreadyDone) {
            document.reference.updateData({
              'Done': false,
              'Task': document['Task']
            });
            //_saved.remove(pair);
          } else {
            document.reference.updateData({
              'Done': true,
              'Task': document['Task']
            });
            //_saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildDoneItem(DocumentSnapshot document) {

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['Task'],
                  style: _biggerFont,
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Text(document['Points']),
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eva Happy List"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushDone),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('Users').document('Testid').collection('Lists').document('gY7SvZ0WyshVYJ4fTNDp').collection('EvasList').snapshots(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading....');
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              //itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
//                if (i.isOdd) return Divider(); /*2*/
//
//                final index = i ~/ 2; /*3*/
//                if (index >= snapshot.data.documents.length) {
//                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//                }
                return _buildTodoItem(snapshot.data.documents[i]);

              });
          }),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTask()),
            );
          },
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Lists')),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Profil')),
          //BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Chat')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _pushDone() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
//          final Iterable<ListTile> tiles = _saved.map(
//                (WordPair pair) {
//              return new ListTile(
//                title: new Text(
//                  pair.asPascalCase,
//                  style: _biggerFont,
//                ),
//              );
//            },
//          );
//          final List<Widget> divided = ListTile.divideTiles(
//            context: context,
//            tiles: tiles,
//          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Done'),
            ),
            body: StreamBuilder(
                stream: Firestore.instance.collection('Todos').where("Done", isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading....');
                  return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      //itemExtent: 80.0,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
//                if (i.isOdd) return Divider(); /*2*/
//
//                final index = i ~/ 2; /*3*/
//                if (index >= snapshot.data.documents.length) {
//                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//                }
                        return _buildDoneItem(snapshot.data.documents[i]);

                      });
                }),
          );
        },
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  TodoListState createState() => new TodoListState();
}

class AddTask extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String _one;
    String _two;

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Add a new Happy item')
        ),
        body: new ListView(

          children: <Widget>[
            new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  hintText: 'Enter something to do...',
                  contentPadding: const EdgeInsets.all(16.0)
              ),
              onChanged: (one) => _one = one,

            ),
            new TextField(
              decoration: new InputDecoration(
                  hintText: 'Enter deadline...',
                  contentPadding: const EdgeInsets.all(16.0)
              ),
              onChanged: (two) => _two = two,

            ),
            new TextField(
              decoration: new InputDecoration(
                  hintText: 'Enter points...',
                  contentPadding: const EdgeInsets.all(16.0)
              ),
              onSubmitted: (val) {
                Firestore.instance.collection('Todos').document().setData({ 'Task' : _one, 'Done': false, "Date": _two, "Points": val});
                Navigator.pop(context);
          },

            )
          ],

        )
//        body: new TextField(
//          autofocus: true,
//          onSubmitted: (val) {
//            Firestore.instance.collection('Todos').document().setData({ 'Task' : val, 'Done': false});
//            //_addTodoItem(val);
//            Navigator.pop(context);
//          },
//          decoration: new InputDecoration(
//              hintText: 'Enter something to do...',
//              contentPadding: const EdgeInsets.all(16.0)
//          ),
//        )
    );
  }
}