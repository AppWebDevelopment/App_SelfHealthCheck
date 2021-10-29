import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:selfchecker/data/dropboxCompanyList.dart';
import 'package:selfchecker/data/companyInfo.dart';
import 'package:selfchecker/enum.dart';

class ManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagerPage();
}

class _ManagerPage extends State<ManagerPage>
    with SingleTickerProviderStateMixin {
  FirebaseDatabase _database;
  DatabaseReference _dbRefComlist;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';

  double _opacity = 0;
  TextEditingController _idTextController;
  TextEditingController _pwTextController;
  TextEditingController _comNameTextController;

  // 회원가입 성공하면 다음 로그인 부터는 자동으로 로그인
  String _savedID;
  String _savedPass;
  String _savedComName;

  List<DropdownMenuItem> _companyItemListforDropMenu = List();
  comItem _comItemDropMenuInit;

  SharedPreferences _pref;

  void _innerLoadData(EnumPrefKey e) async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      switch (e) {
        case EnumPrefKey.ComID:
          var value = _pref.getString(EnumPrefKey.ComID.toString());
          _savedID = (value == null) ? "" : value;
          _idTextController = TextEditingController(text: _savedID);
          break;
        case EnumPrefKey.ComPW:
          var value = _pref.getString(EnumPrefKey.ComPW.toString());
          _savedPass = (value == null) ? "" : value;
          _pwTextController = TextEditingController(text: _savedPass);
          break;
        case EnumPrefKey.ComName:
          var value = _pref.getString(EnumPrefKey.ComName.toString());
          _savedComName = (value == null) ? "" : value;
          _comNameTextController = TextEditingController(text: _savedComName);
          break;
      }
    });
  }

  void _innerSaveData(EnumPrefKey e, String value) async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      switch (e) {
        case EnumPrefKey.ComID:
          _pref.setString(EnumPrefKey.ComID.toString(), value);
          break;
        case EnumPrefKey.ComPW:
          _pref.setString(EnumPrefKey.ComPW.toString(), value);
          break;
        case EnumPrefKey.ComName:
          _pref.setString(EnumPrefKey.ComName.toString(), value);
          break;
      }
    });
  }


  @override
  void initState() {
    super.initState();

    _database = FirebaseDatabase(databaseURL: _databaseURL);

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _comNameTextController = TextEditingController();

    _companyItemListforDropMenu.clear();
    _companyItemListforDropMenu = comItemDropBox().comItemDropBoxList;
    _comItemDropMenuInit = _companyItemListforDropMenu[0].value;

    _innerLoadData(EnumPrefKey.ComID);
    _innerLoadData(EnumPrefKey.ComPW);
    _innerLoadData(EnumPrefKey.ComName);
  }

  @override
  void dispose() {
    super.dispose();
    _idTextController.dispose();
    _pwTextController.dispose();
    _comNameTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            children: <Widget>[
              Image.asset("repo/images/img11.png",
                  height: 1000, fit: BoxFit.fitHeight),
              ListView(children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        '관리자 로그인',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Container(
                      alignment: Alignment.center,
                      //color: Colors.white,
                      child: DropdownButton(
                        items: _companyItemListforDropMenu,
                        onChanged: (value) {
                          setState(() {
                            _comItemDropMenuInit = value;

                            _innerSaveData(EnumPrefKey.ComName,
                                _comItemDropMenuInit.value);

                            _innerLoadData(EnumPrefKey.ComName);
                          });
                        },
                        value: _comItemDropMenuInit,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: Container(
                      //color: Colors.white,
                      child: TextField(
                        readOnly: true,
                        controller: _comNameTextController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: '회사',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: Container(
                      //color: Colors.white,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                        controller: _idTextController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: '관리자아이디',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: Container(
                      //color: Colors.white,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _pwTextController,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                        obscureText: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: '비밀번호', border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      CupertinoButton(
                          onPressed: () {
                            if (_comNameTextController.value.text == '') {
                              makeDialog('회사를 선택해주세요');
                            } else {
                              _dbRefComlist =
                                  _database.reference().child('companyList');

                              if (_idTextController.value.text.length == 0 ||
                                  _pwTextController.value.text.length == 0) {
                                makeDialog('빈칸이 있습니다');
                              } else {
                                _dbRefComlist
                                    .child(_comNameTextController.value.text)
                                    .onValue
                                    .listen((event) {
                                  if (event.snapshot.value == null) {
                                    makeDialog('아이디가 없습니다');
                                  } else {
                                    CompanyInfo comInfo =
                                        CompanyInfo.fromSnapshot(
                                            event.snapshot);
                                    var bytes = utf8
                                        .encode(_pwTextController.value.text);
                                    var digest = sha1.convert(bytes);
                                    if (comInfo.pw == digest.toString()) {
                                      _innerSaveData(EnumPrefKey.ComID,
                                          _idTextController.value.text);
                                      _innerSaveData(EnumPrefKey.ComPW,
                                          _pwTextController.value.text);

                                      Navigator.of(context)
                                          .pushReplacementNamed('/adminIntro',
                                              arguments: comInfo);
                                    } else {
                                      makeDialog('비밀번호가 틀립니다');
                                    }
                                  }
                                });
                              }
                            }
                          },
                          child: Text(
                            '관리자 로그인',
                            style: TextStyle(color: Colors.white,fontSize: 15),
                          ))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )
                ])
              ]),
            ],
          ),
        ),
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
