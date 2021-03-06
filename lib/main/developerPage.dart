import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfchecker/data/companyInfo.dart';
import 'package:selfchecker/data/notiDeveloperData.dart';
import 'package:flutter/cupertino.dart';

class DeveloperPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeveloperPage();
}

class _DeveloperPage extends State<DeveloperPage> {
  FirebaseDatabase _database;
  DatabaseReference _dbRefComList;
  DatabaseReference _dbRefNotification;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';

  //String companyName;

  TextEditingController _companyTextController;
  TextEditingController _comEmployeePwTextController;
  TextEditingController _comPwTextController;
  TextEditingController _comPwCheckTextController;
  TextEditingController _PhoneTextController;
  TextEditingController _NameTextController;
  TextEditingController _AdressTextController;

  TextEditingController _notificationInfoController;
  TextEditingController _notificationNotifyController;

  TextEditingController _question1;
  TextEditingController _question2;
  TextEditingController _question3;
  TextEditingController _question4;
  TextEditingController _question5;
  TextEditingController _question6;
  TextEditingController _question7;


  @override
  void initState() {
    super.initState();
    _companyTextController = TextEditingController();
    _comEmployeePwTextController = TextEditingController();
    _comPwTextController = TextEditingController();
    _comPwCheckTextController = TextEditingController();
    _PhoneTextController = TextEditingController();
    _NameTextController = TextEditingController();
    _AdressTextController = TextEditingController();
    _notificationInfoController = TextEditingController();
    _notificationNotifyController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    _dbRefComList = _database.reference().child('companyList');
    _dbRefNotification = _database.reference().child('notification');
  }

  @override
  void dispose(){
    super.dispose();
    _companyTextController.dispose();
    _comEmployeePwTextController.dispose();
    _comPwTextController.dispose();
    _comPwCheckTextController.dispose();
    _PhoneTextController.dispose();
    _NameTextController.dispose();
    _AdressTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('????????? ?????? ?????????'),
      ),
      body: Container(
        child: ListView(children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _companyTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '2??? ?????? ??????????????????',
                      labelText: '??????????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _comEmployeePwTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '4??? ??????????????????',
                      labelText: '??????????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _comPwTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '4??? ??????????????????',
                      labelText: '?????????????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _comPwCheckTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '???????????????????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _PhoneTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '???????????????=?????????ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _NameTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '???????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _AdressTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                CupertinoButton(
                  onPressed: () {
                    if (_companyTextController.value.text.length >= 2 &&
                        _comPwTextController.value.text.length >= 4) {
                      if (_comPwTextController.value.text ==
                          _comPwCheckTextController.value.text) {
                        var bytes =
                            utf8.encode(_comPwTextController.value.text);
                        var digest = sha1.convert(bytes);
                        _dbRefComList
                            .child(_companyTextController.value.text)
                            .update(CompanyInfo(
                              _PhoneTextController.value.text,
                              //id
                              _comEmployeePwTextController.value.text,
                              //??????????????????
                              _PhoneTextController.value.text,
                              //?????????
                              _companyTextController.value.text,
                              //????????????
                              digest.toString(),
                              //????????????
                              _NameTextController.value.text,
                              //?????????
                              _AdressTextController.value.text,
                              //??????
                              DateTime.now().toIso8601String(), //????????????
                            ).toJson())
                            .then((_) {
                          makeDialog('????????????');

                          _companyTextController.clear();
                          _comPwTextController.clear();
                          _comPwCheckTextController.clear();
                          _PhoneTextController.clear();
                          _NameTextController.clear();
                          _AdressTextController.clear();
                          _comEmployeePwTextController.clear();
                        });
                      } else {
                        makeDialog('??????????????? ????????????');
                      }
                    } else {
                      makeDialog('????????? ????????????');
                    }
                  },
                  child: Text(
                    '????????????',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _notificationInfoController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '???????????? ??????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _notificationNotifyController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: '????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoButton(
                  onPressed: () {
                    _dbRefNotification
                        .update(NotiDeveloperData(
                        _notificationInfoController.value.text,
                        _notificationNotifyController.value.text,
                        DateTime.now().toIso8601String())
                        .toJson())
                        .then((_) {
                      makeDialog('??????????????????');

                    });
                  },
                  child: Text(
                    '?????? ??????',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                ),
              ])
        ]),
      ),
    );
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text(text),
          );
        });
  }
}
