import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'ListApp',
      home: MainRoute(),
      initialRoute: '/main',
      routes: {
        '/main': (context) => MainRoute(),
        '/create': (context) => CreateRoute(),
        '/settings': (context) => SettingsRoute(),
        "/play": (context) => PlayRoute(),
        "/finish": (context) => FinishRoute(),
        "/edit": (context) => EditRoute()
      }));
}

class MainRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainRoute();
  }
}

class _MainRoute extends State<MainRoute> {
  List<String> _lists = [];

  @override
  void initState() async {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'list_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE listrmb(id INTEGER PRIMARY KEY, title TEXT, items )',
        );
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('List Quizzer'),
            leading: ElevatedButton(
                child: Image.asset("assets/settings.jpg"),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                })),
        body: Center(
            child: Column(children: [
          Container(
              margin: EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create');
                  },
                  child: Text("Create new list"))),
          Expanded(child: Lists(_lists))
        ])));
  }
}

class Lists extends StatelessWidget {
  final List<String> lists;
  Lists(this.lists);

  Widget _buildListItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/play.jpg'),
          Text(lists[index], style: TextStyle(color: Colors.deepPurple)),
          ElevatedButton(
              child: Text("options"),
              onPressed: () {
                //popup dialog or something
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildListItem,
      itemCount: lists.length,
    );
  }
}

class ListModel extends ChangeNotifier {
  String title = "";
  List<String> items = [];

  /// An unmodifiable view of the items in the cart.
  List<String> get getItems {
    return this.items;
  }

  String get getTitle {
    return this.title;
  }

  void set setTitle(String replacement) {
    this.title = replacement;
    notifyListeners();
  }

  void set deleteItem(int index) {
    this.items.removeAt(index); ///need a pop or something
    notifyListeners();
  }

  void setItem(int index, String item) {
    this.items.insert(index, item);  ///need a replace method or something
    notifyListeners();
  }

  ListModel(String title) {
    this.title = title;
  }

  ListModel.withItems(String title, List<String> items) {
    this.title = title;
    this.items = items;
  }
}

class CreateRoute extends StatelessWidget {
  String tempTitle = "";
  CreateRoute({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New List'),
      ),
      body: Center(
          child: Column(
        children: [
          Row(children: [
            ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                  //reset state to zero
                }),
            ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  //back to home screen but save data
                })
          ]),
          TextField(
            onChanged: (text) {
              tempTitle = text;
            },
            decoration: InputDecoration(
              labelText: 'List Title', 
              hintText: 'Enter List Title'
            )
          ),
          ListView(//must make this dynamic
            children: [
              Row(
                children: [
                  TextField(
                    onChanged: (text) {
                      
                    },
                    decoration: InputDecoration(
                      labelText: 'List Item', 
                      hintText: 'Enter List Item'
                    )
                  ),
                  ElevatedButton(child: Text("delete item"), onPressed: () {})
                ]
              )
            ]
          ),
          ElevatedButton(child: Text("Add List Item"), onPressed: () => {})
        ],
      )),
    );
  }
}

class addList extends StatelessWidget {
  final List<String> addCounter = [];
  Lists(this.lists);

  Widget _buildAddListItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/play.jpg'),
          Text(lists[index], style: TextStyle(color: Colors.deepPurple)),
          ElevatedButton(
              child: Text("options"),
              onPressed: () {
                //popup dialog or something
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildAddListItem,
      itemCount: lists.length,
    );
  }
}

//must think about what settings to add
class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
          child: Column(children: [
        ElevatedButton(
            child: Text("Back"),
            onPressed: () => {
                  //navi back to home
                }),
        Row()
      ])),
    );
  }
}

class PlayRoute extends StatelessWidget {
  const PlayRoute({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play'),
      ),
      body: Center(
          child: Column(
        children: [
          Row(children: [
            ElevatedButton(
                child: Text("Exit"),
                onPressed: () => {
                      //navi back to homescreen without progress saved
                    }),
            ElevatedButton(
                child: Text("Continue Early"),
                onPressed: () => {
                      //navi to finish screen quick
                    })
          ]),
          Center(
              child: Column(
            children: [
              Text("List Title"),
              Row(), //progress, two counts of answered correctly and remaining
              Row(), //wrong or right answer indicator for just entered answer
              Row(children: [
                TextField(
                    decoration: InputDecoration(labelText: "Enter list items")),
                ElevatedButton(
                    child: Text("Submit"),
                    onPressed: () => {
                          //empty textinput and update values
                        })
              ])
            ],
          ))
        ],
      )),
    );
  }
}

class FinishRoute extends StatelessWidget {
  const FinishRoute({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Finish'),
      ),
      body: Center(
          child: Column(
        children: [
          Row(), //session performance values, maybe time, how many wrong answers, finished banner, missed values
          Row(children: [
            ElevatedButton(
                child: Text("Redo"),
                onPressed: () => {
                      //back to play screen
                    }),
            ElevatedButton(
                child: Text("Continue"),
                onPressed: () => {
                      //back to main screen and save values
                    })
          ])
        ],
      )),
    );
  }
}

class EditRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit List'),
      ),
      body: Center(
          child: Column(children: [
        Row(children: [
          ElevatedButton(
              child: Text("Cancel"),
              onPressed: () => {
                    //navi back to home without saving
                  }),
          ElevatedButton(
              child: Text("Save"),
              onPressed: () => {
                    //navi back to home without saving
                  })
        ]),
        Text("List Title"),
        Row(children: [
          TextField(),
          ElevatedButton(
              child: Text("Delete List Item"),
              onPressed: () => {
                    //delete from listview
                  })
        ]) //has to be a listview of rows
      ])),
    );
  }
}
