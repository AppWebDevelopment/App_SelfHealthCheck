import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class comItem{
  String value;
  int number;

  comItem(this.value, this.number);
}

class comItemDropBox{

  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';

  int number = 1;

  List<DropdownMenuItem> comItemDropBoxList = List();

  comItemDropBox(){

    comItemDropBoxList.add(DropdownMenuItem(
      child: Text('회사를 선택하세요'),
      value: comItem('',0),
    ));

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('companyList');

    reference
        .onChildAdded
        .listen((event) async{

      comItemDropBoxList.add(DropdownMenuItem(
        child: Text(event.snapshot.key),
        value: comItem(event.snapshot.key,number),
      ));

      number++;

    });
  }
}
