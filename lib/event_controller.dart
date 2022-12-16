import 'package:flutter/material.dart';
import 'model.dart';

class BTCController{

  void addToModelList(String string){
    BTCList().addToList(string);
  }
  getList(){
    return BTCList().todoList;
  }

  launchData(){
    return BTCList().readFile();
  }

  setList(Future<List<String>> list){
    BTCList().setList(list);
  }

  closeDb(){
    BTCList().close();
  }
}