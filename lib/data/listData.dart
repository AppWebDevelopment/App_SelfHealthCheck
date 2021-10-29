import 'package:flutter/material.dart';

class Item{
  String value;

  Item(this.value);
}

class CheckedItem{
  List<DropdownMenuItem> checkedItemList = List();

  CheckedItem(){
    checkedItemList.add(DropdownMenuItem(
        child: Text('열감'),
    value: Item('fever'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('기침'),
      value: Item('cough'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('인후'),
      value: Item('throatpain'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('호흡'),
      value: Item('dyspnea'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('개인활동'),
      value: Item('activity'),));
    checkedItemList.add(DropdownMenuItem(
      child: Text('그외 단체활동'),
      value: Item('groupact'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('접촉'),
      value: Item('contact'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('체크시간'),
      value: Item('checktime'),));
/*
    checkedItemList.add(DropdownMenuItem(
      child: Text('전번'),
      value: Item('id'),));

    checkedItemList.add(DropdownMenuItem(
      child: Text('이름'),
      value: Item('username'),));
*/
  }
}
