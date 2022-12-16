import 'package:flutter/material.dart';
import 'model.dart';
import 'event_controller.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'db/database.dart';


void main() {
  runApp(Todo());
}

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jordi_pascual_sanchez_todo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        '/': (context) => TodoList(),
      },
    );
  }
}

final ToDoController _controlador = ToDoController();

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // text field
  final TextEditingController _textFieldController = TextEditingController();
  late final Future<List<String>> _initialList;
  //late AppDb _db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_db = AppDb();

    _initialList = _controlador.launchData();
  }
  @override
  void dispose(){
    super.dispose();
    _controlador.closeDb();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _initialList,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {

        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ];
        }
        _controlador.setList(_initialList);
        return Scaffold(
          appBar: AppBar(title: const Text('To-Do List')),
          body: ListView(children: _getItems()),
          // add items to the to-do list
          floatingActionButton: FloatingActionButton(
              onPressed: () => _displayDialog(context),
              tooltip: 'Add Item',
              child: Icon(Icons.add)),
        );
      },
    );
  }

  // // app layout
  // return Scaffold(
  //   appBar: AppBar(title: const Text('To-Do List')),
  //   body: ListView(children: _getItems()),
  //   // add items to the to-do list
  //   floatingActionButton: FloatingActionButton(
  //       onPressed: () => _displayDialog(context),
  //       tooltip: 'Add Item',
  //       child: Icon(Icons.add)),
  // );
  void _addTodoItem(String title) {
    setState(() {
      _controlador.addToModelList(_textFieldController.text);
    });
    _textFieldController.clear();
  }

  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }

  Future<AlertDialog> _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  // final entity = EventsCompanion(
                  //   desc: Value(_textFieldController.text),
                  // );

                  //_db.insertEvent(entity);

                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              // cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }) as Future<AlertDialog>;
  }

  // iterates through our to3do list titles.
  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _controlador.getList()) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }
}