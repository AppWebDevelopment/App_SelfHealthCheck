import 'package:flutter/material.dart';

class DateItem{
  String value;

  DateItem(this.value);
}

class CheckedDateItem{
  List<DropdownMenuItem> checkedItemDateList = List();
  List<dynamic> dateTiemList = List();

  var year = DateTime.now().year;
  var month = DateTime.now().month;
  var day = DateTime.now().day;

  var year1 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -1).year;
  var month1 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -1).month;
  var day1 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -1).day;

  var year2 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -2).year;
  var month2 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -2).month;
  var day2 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -2).day;

  var year3 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -3).year;
  var month3 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -3).month;
  var day3 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -3).day;

  var year4 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -4).year;
  var month4 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -4).month;
  var day4 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -4).day;

  var year5 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -5).year;
  var month5 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -5).month;
  var day5 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -5).day;

  var year6 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -6).year;
  var month6 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -6).month;
  var day6 = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day -6).day;

  CheckedDateItem(){
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('금일 $month.$day'),
      value: DateItem('$year$month$day'),));
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('1일전 $month1.$day1'),
      value: DateItem('$year1$month1$day1'),));
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('2일전 $month2.$day2'),
      value: DateItem('$year2$month2$day2'),));
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('3일전 $month3.$day3'),
      value: DateItem('$year3$month3$day3'),));
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('4일전 $month4.$day4'),
      value: DateItem('$year4$month4$day4'),));
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('5일전 $month5.$day5'),
      value: DateItem('$year5$month5$day5'),));
    checkedItemDateList.add(DropdownMenuItem(
      child: Text('6일전 $month6.$day6'),
      value: DateItem('$year6$month6$day6'),));
  }
}
