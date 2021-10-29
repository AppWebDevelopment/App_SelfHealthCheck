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
        title: Text('개발자 관리 페이지'),
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
                      hintText: '2자 이상 입력해주세요',
                      labelText: '회사이름추가',
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
                      hintText: '4자 입력해주세요',
                      labelText: '직원회사비번',
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
                      hintText: '4자 입력해주세요',
                      labelText: '관리자회사비번',
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
                      labelText: '관리자회사비번확인',
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
                      labelText: '대표연락처=관리자ID',
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
                      labelText: '담당자성함',
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
                      labelText: '회사주소',
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
                              //직원회사비번
                              _PhoneTextController.value.text,
                              //연락처
                              _companyTextController.value.text,
                              //회사이름
                              digest.toString(),
                              //회사비번
                              _NameTextController.value.text,
                              //담당자
                              _AdressTextController.value.text,
                              //주소
                              DateTime.now().toIso8601String(), //생성시간
                            ).toJson())
                            .then((_) {
                          makeDialog('생성완료');

                          _companyTextController.clear();
                          _comPwTextController.clear();
                          _comPwCheckTextController.clear();
                          _PhoneTextController.clear();
                          _NameTextController.clear();
                          _AdressTextController.clear();
                          _comEmployeePwTextController.clear();
                        });
                      } else {
                        makeDialog('비밀번호가 틀립니다');
                      }
                    } else {
                      makeDialog('길이가 짧습니다');
                    }
                  },
                  child: Text(
                    '회사추가',
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
                      labelText: '개발정보 입력',
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
                      labelText: '공지사항',
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
                      makeDialog('공지생성완료');

                    });
                  },
                  child: Text(
                    '공지 갱신',
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
