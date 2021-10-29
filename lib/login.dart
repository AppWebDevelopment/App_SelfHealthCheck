import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfchecker/data/user.dart';
import 'package:selfchecker/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:selfchecker/data/dropboxCompanyList.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:selfchecker/data/notiDeveloperData.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {
  FirebaseDatabase _database;
  DatabaseReference _dbRefComnameUserlist;
  DatabaseReference dbRefNoti;
  DatabaseReference dbRefComNoti;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';

  double _opacity = 0;
  TextEditingController _idTextController;
  TextEditingController _pwTextController;
  TextEditingController _comNameTextController;

  // 회원가입 성공하면 다음 로그인 부터는 자동으로 로그인
  String _savedID;
  String _savedPass;
  String _savedComName;

  String _developerInfoST = '';
  String _developerNotificationST = '';

  NotiDeveloperData _developerInfo;

  List<DropdownMenuItem> _companyItemListforDropMenu = List();
  comItem _comItemDropMenuInit;

  SharedPreferences _pref;

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool pushCheck = true;

  //void _loadData() async{
  //  var key = "push";
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pushCheck = pref.getBool(key);
  // }

  void _innerLoadData(EnumPrefKey e) async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      switch (e) {
        case EnumPrefKey.UserID:
          var value = _pref.getString(EnumPrefKey.UserID.toString());
          _savedID = (value == null) ? "" : value;
          _idTextController = TextEditingController(text: _savedID);
          break;
        case EnumPrefKey.UserPW:
          var value = _pref.getString(EnumPrefKey.UserPW.toString());
          _savedPass = (value == null) ? "" : value;
          _pwTextController = TextEditingController(text: _savedPass);
          break;
        case EnumPrefKey.UserComName:
          var value = _pref.getString(EnumPrefKey.UserComName.toString());
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
        case EnumPrefKey.UserID:
          _pref.setString(EnumPrefKey.UserID.toString(), value);
          break;
        case EnumPrefKey.UserPW:
          _pref.setString(EnumPrefKey.UserPW.toString(), value);
          break;
        case EnumPrefKey.UserComName:
          _pref.setString(EnumPrefKey.UserComName.toString(), value);
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    dbRefNoti = _database.reference().child('notification');

    dbRefNoti.onValue.listen((event) {
      _developerInfo = NotiDeveloperData.fromSnapshot(event.snapshot);
      setState(() {
        _developerInfoST = _developerInfo.info;
        _developerNotificationST = _developerInfo.notify;
      });
    });

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _comNameTextController = TextEditingController();

    _companyItemListforDropMenu.clear();
    _companyItemListforDropMenu = comItemDropBox().comItemDropBoxList;
    _comItemDropMenuInit = _companyItemListforDropMenu[0].value;

    _innerLoadData(EnumPrefKey.UserID);
    _innerLoadData(EnumPrefKey.UserPW);
    _innerLoadData(EnumPrefKey.UserComName);

    // _firebaseMessaging.getToken().then((value) {
    //   // print(value);
    // });

    // _firebaseMessaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //   // _loadData();
    //   //print(pushCheck);
    //   if (pushCheck) {
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //       ),
    //     );
    //   }
    // }, onLaunch: (Map<String, dynamic> message) async {
    //   //  _loadData();
    //   if (pushCheck) {
    //     Navigator.of(context).pushNamed(('/'));
    //   }
    // }, onResume: (Map<String, dynamic> message) async {
    //   //  _loadData();
    //   if (pushCheck) {
    //     Navigator.of(context).pushNamed('/');
    //   }
    // });
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
        decoration: (BoxDecoration(image: DecorationImage(
          image: AssetImage("repo/images/img0.png"),
          fit: BoxFit.cover,
        ))),
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              //Image.asset("repo/images/img0.png",
              //    height: 1000, fit: BoxFit.cover),
              ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(10,0,10,0) ,
                        alignment: Alignment.centerRight,
                        height: 20,
                        child: Text(
                          _developerInfoST,
                          style: TextStyle(
                              fontSize: 15, color: Colors.blueGrey[300]),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(10,0,10,0) ,
                        alignment: Alignment.center,
                        height: 75,
                        width: 200,
                        child: Text(
                          _developerNotificationST,
                          style: TextStyle(
                            fontSize: 15, color: Colors.red[900], fontWeight: FontWeight.bold, shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                            ), ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        child: Center(
                          child: Text(
                            '출근 자가 체크',
                            style: TextStyle(fontSize: 30, color: Colors.white),

                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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

                                _innerSaveData(EnumPrefKey.UserComName,
                                    _comItemDropMenuInit.value);

                                _innerLoadData(EnumPrefKey.UserComName);
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
                              hintText: '위에서 회사선택',
                              hintStyle: TextStyle(fontSize: 10, color: Colors.white),
                              labelText: '회사',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: Container(
                          //color: Colors.white,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _idTextController,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: '전화번호입력( - 기호생략)',
                              hintStyle: TextStyle(fontSize: 10, color: Colors.white),
                              labelText: '아이디',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: Container(
                         // color: Colors.white,
                          child: TextField(
                            controller: _pwTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                            obscureText: true,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: '비밀번호',
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          CupertinoButton(
                              onPressed: () async {
                                final idSave = await Navigator.of(context)
                                    .pushNamed('/sign');
                              },
                              child: Text(
                                '회원가입',
                                style: TextStyle(color: Colors.white,fontSize: 15),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          CupertinoButton(
                              onPressed: () {
                                if (_comNameTextController.value.text == '') {
                                  makeDialog('회사를 선택해주세요');
                                } else {
                                  _dbRefComnameUserlist = _database
                                      .reference()
                                      .child(_comNameTextController.value.text)
                                      .child('user');

                                  if (_idTextController.value.text.length ==
                                          0 ||
                                      _pwTextController.value.text.length ==
                                          0) {
                                    makeDialog('빈칸이 있습니다');
                                  } else {
                                    _dbRefComnameUserlist
                                        .child(_idTextController.value.text)
                                        .onValue
                                        .listen((event) {
                                      if (event.snapshot.value == null) {
                                        makeDialog('아이디가 없습니다');
                                      } else {
                                        _dbRefComnameUserlist
                                            .child(_idTextController.value.text)
                                            .onChildAdded
                                            .listen((event) {
                                          User user =
                                              User.fromSnapshot(event.snapshot);
                                          var bytes = utf8.encode(
                                              _pwTextController.value.text);
                                          var digest = sha1.convert(bytes);
                                          if (user.pw == digest.toString()) {
                                            _innerSaveData(EnumPrefKey.UserID,
                                                _idTextController.value.text);
                                            _innerSaveData(EnumPrefKey.UserPW,
                                                _pwTextController.value.text);

                                            Navigator.of(context)
                                                .pushReplacementNamed('/intro',
                                                    arguments: user);
                                          } else {
                                            makeDialog('비밀번호가 틀립니다');
                                          }
                                        });
                                      }
                                    });
                                  }
                                }
                              },
                              child: Text(
                                '로그인',
                                style: TextStyle(color: Colors.white,fontSize: 15),
                              ))
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/manager');
        },
        backgroundColor: Colors.black12,
        mini: true,
        child: new Icon(CupertinoIcons.chart_bar_square),
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
