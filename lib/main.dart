import 'package:flutter/material.dart';
import 'model.dart';
import 'orden_controller.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'db/database.dart';


void main() {
  runApp(BTC());
}

class BTC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'raul-tadeo-btc',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        '/': (context) => BTCList(),
      },
    );
  }
}

final BTCController _controlador = BTCController();

class BTCList extends StatefulWidget {
  @override
  _BTCListState createState() => _BTCListState();
}

class _BTCListState extends State<BTCList> {
  final TextEditingController _textFieldController = TextEditingController();
  late final Future<List<String>> _initialList;
  @override
  void initState() {
    super.initState();
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
              child: Text('Esperando resultado...'),
            ),
          ];
        }
        _controlador.setList(_initialList);
        return Scaffold(
          appBar: AppBar(title: const Text('Lista BTC')),
          body: ListView(children: _getItems()),
          floatingActionButton: FloatingActionButton(
              onPressed: () => _displayDialog(context),
              tooltip: 'A??adir Item',
              child: Icon(Icons.add)),
        );
      },
    );
  }

  void _addTodoItem(String title) {
    setState(() {
      _controlador.addToModelList(_textFieldController.text);
    });
    _textFieldController.clear();
  }

  Widget _buildBTCItem(String title) {
    return ListTile(title: Text(title));
  }

  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('A??adir Compra/Venta'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Tipo: C/V'),
            ),

            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('A??adir'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }) as Future<AlertDialog>;
  }

  List<Widget> _getItems() {
    final List<Widget> _btcWidgets = <Widget>[];
    for (String title in _controlador.getList()) {
      _btcWidgets.add(_buildBTCItem(title));
    }
    return _btcWidgets;
  }
}