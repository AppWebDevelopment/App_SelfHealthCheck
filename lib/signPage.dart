import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfchecker/data/user.dart';
import 'package:selfchecker/data/dropboxCompanyList.dart';
import 'package:selfchecker/data/companyInfo.dart';
import 'package:selfchecker/main/policy.dart';
import 'package:flutter/cupertino.dart';

class SignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignPage();
}

class _SignPage extends State<SignPage> {
  FirebaseDatabase _database;
  DatabaseReference dbRefComnameUserList;
  DatabaseReference dbRefComlistComname;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';
  String companyName;
  String companyPw;

  TextEditingController _idTextController;
  TextEditingController _pwTextController;
  TextEditingController _pwCheckTextController;
  TextEditingController _nameTextController;
  TextEditingController _placeTextController;
  TextEditingController _companyPwTextController;

  List<DropdownMenuItem> _companyItemListforDropMenu = List();
  comItem _comItemDropMenuInit;

  bool _isPolicy = false;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();
    _nameTextController = TextEditingController();
    _placeTextController = TextEditingController();
    _companyPwTextController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);

    _companyItemListforDropMenu.clear();
    _companyItemListforDropMenu = comItemDropBox().comItemDropBoxList;
    _comItemDropMenuInit = _companyItemListforDropMenu[0].value;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _idTextController.dispose();
  //   _pwTextController.dispose();
  //   _pwTextController.dispose();
  //   _nameTextController.dispose();
  //   _placeTextController.dispose();
  //   _companyPwTextController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
        title: Text('????????????',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: Colors.blueGrey[100],
        child: ListView(children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton(
                  items: _companyItemListforDropMenu,
                  onChanged: (value) {
                    comItem SeclectItem = value;
                    setState(() {
                      _comItemDropMenuInit = SeclectItem;

                      dbRefComlistComname = _database
                          .reference()
                          .child('companyList')
                          .child(_comItemDropMenuInit.value);

                      dbRefComlistComname.onValue.listen((event) {
                        CompanyInfo comInfo =
                            CompanyInfo.fromSnapshot(event.snapshot);

                        companyPw = comInfo.pwEmployee;

                      });
                    });
                  },
                  value: _comItemDropMenuInit,
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _companyPwTextController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '4??????',
                      labelText: '??????????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _idTextController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '??????????????????( - ????????????)',
                      labelText: '?????????=?????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _pwTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '6??? ?????? ??????????????????',
                      labelText: '????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _pwCheckTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')),],
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '??????????????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nameTextController,

                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '??????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _placeTextController,
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp('??????')),],
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '????????? 3?????????',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),


            Container(
              width: 300,
              height: 55,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                        '???????????? ??? ??????????????? ????????????????????????',
                        style: TextStyle(color: Colors.black45),
                      )),
                  CupertinoSwitch(
                    value: _isPolicy,
                    onChanged: (value) {
                      setState(() {
                        _isPolicy = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            ),



                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/policy');
                  },

                  child: Text(
                    '  *???????????? ????????????',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

        // FlatButton(
        //     onPressed: (){
        //
        //       print(_comItemDropMenuInit.value);
        //       dbRefComnameUserList =  _database
        //           .reference()
        //           .child(_comItemDropMenuInit.value)
        //           .child('user');
        //
        //       dbRefComnameUserList.child('01033333333').remove();
        //     },
        //   child: Text(
        //     '?????????',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //  color: Colors.blueAccent,
        //),

            CupertinoButton(
                  onPressed: () async{
                    if(_isPolicy==false){
                      makeDialog('??????????????? ???????????? ??????????????? ???????????????');
                    }else {
                      if (_comItemDropMenuInit.value == '') {
                        makeDialog('????????? ???????????????');
                      } else {
                        dbRefComnameUserList = _database
                            .reference()
                            .child(_comItemDropMenuInit.value)
                            .child('user');

                          if (_idTextController.value.text.length >= 4 &&
                              _pwTextController.value.text.length >= 6) {
                            if (_pwTextController.value.text ==
                                _pwCheckTextController.value.text) {
                              if (_companyPwTextController.value.text ==
                                  companyPw) {

                                String tempNameText=_nameTextController.value.text;

                               if(_nameTextController.value.text.length==2)
                                 {
                                   tempNameText =_nameTextController.value.text[0]+"???"+_nameTextController.value.text[1];
                                 }

                                var bytes =
                                utf8.encode(_pwTextController.value.text);
                                var digest = sha1.convert(bytes);

                                dbRefComnameUserList.child(
                                    _idTextController.value.text).remove();

                                dbRefComnameUserList
                                    .child(_idTextController.value.text)
                                    .push()
                                    .set(User(
                                  _idTextController.value.text,
                                  digest.toString(),
                                  DateTime.now().toIso8601String(),
                                  tempNameText,
                                  _placeTextController.value.text,
                                  _comItemDropMenuInit.value,
                                ).toJson())
                                    .then((_) async{
                                  makeDialog2('????????? ?????????????????????.');
                                });

                              } else {
                                makeDialog('????????????????????? ????????????');
                              }
                            } else {
                              makeDialog('??????????????? ????????????');
                            }
                          } else {
                            makeDialog('????????? ????????????');
                          }

                      }
                    }
                  },



                  child: Text(
                    '????????????',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.indigo[900],
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

  void makeDialog2(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text(text),
            actions: <Widget>[
              new CupertinoButton(
                child: new Text("??????"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                 // Navigator.of(context).pushReplacementNamed('/');

                },
              ),
            ],
          );
        }

    );
  }

}
