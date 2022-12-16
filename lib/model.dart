import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'event_controller.dart';
import 'db/database.dart';
import 'package:drift/drift.dart';
import 'dart:io';

class BTCList{

  static final BTCList _modelo = BTCList._internal();

  factory BTCList() {
    return _modelo;
  }

  BTCList._internal():
        _todoList = <String>[];

  List<String> _todoList;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test1.txt');
  }

  writeFile(String text) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(text+"\r\n", mode: FileMode.append);
  }

  Future<List<String>> readFile() async {
    try {
      _db = AppDb();
      List<String> _lista = <String>[];
      List<Event> events = await _db.getEvents();
      for(var event in events){
        _lista.add(event.desc);
      }

      return _lista;
    } catch (e) {
      return [];
    }
  }

  addToList (String value) {
    _todoList.add(value);
    insertDb(value);
    writeFile(value);
  }

  setList(Future<List<String>> list) async{
    _todoList = await list;
  }

  close(){
    _db.close();
  }

  List<String> get todoList => _todoList;
}


late AppDb _db;

insertDb(String string){
  final entity = EventsCompanion(
    desc: Value(string),
  );

  _db.insertEvent(entity);
}