import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/checkList.dart';
import 'package:selfchecker/data/user.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:selfchecker/data/notiComData.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckCard {
  String quary;
  bool isChecked = false;

  CheckCard(this.quary);
}


class CheckPage extends StatefulWidget {
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  FirebaseDatabase _database;
  DatabaseReference _dbRefComnameDate;
  //DatabaseReference _dbRefComNofi;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';
  bool _isNoti= false;
  NotiComData _comNotifyData;

  List<CheckCard> _checkCards = new List();

  var _year = DateTime.now().year;
  var _month = DateTime.now().month;
  var _day = DateTime.now().day;


  void launchinbrowser(String url) async{
    if(await canLaunch(url))
      {
        await launch(url, forceSafariVC: true,
        forceWebView: true,);
      } else{makeDialog('브라우저에서 $url 열기 실패!');}
  }

  void initState() {
    super.initState();

    _database = FirebaseDatabase(databaseURL: _databaseURL);

    _checkCards.add(CheckCard('발열감'));
    _checkCards.add(CheckCard('기침'));
    _checkCards.add(CheckCard('목 쓰림, 아픔, 콧물, 가래'));
    _checkCards.add(CheckCard('가슴통증, 호흡 곤란(숨가쁨)'));
    _checkCards.add(CheckCard('실내 운동, 종교, 모임 활동'));
    _checkCards.add(CheckCard('그 밖의 5인 이상 단체 활동'));
    _checkCards.add(CheckCard('가족 및 주변인의 상태이상'));

    _year = DateTime.now().year;
    _month = DateTime.now().month;
    _day = DateTime.now().day;

  }

  @override
  Widget build(BuildContext context) {

    final User user = ModalRoute.of(context).settings.arguments;
    final String id = user.id;
    final String userName = user.username;
    final String userPlace = user.userplace;
    final String userComName = user.userCompanyName;
    final String userReservFirst = (user.reservationFirst == null) ? '미정' : user.reservationFirst;
    final String userReservSecond = (user.reservationSecond == null) ? '미정' : user.reservationSecond;

    const url = "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/question-and-answers-hub/q-a-detail/coronavirus-disease-covid-19#:~:text=symptoms";

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.brown[800],
          onPressed: (){
          Navigator.of(context).pushReplacementNamed('/intro',arguments: user);
          },),
        middle: Text(
          '아래 중 해당항목 선택',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[300],
      ),
      backgroundColor: Colors.brown[200],
      child: ListView(

        children: <Widget>[

          SizedBox(
            height: MediaQuery.of(context).size.height/50,
          ),

          Container(
            height: 70,
            child: Center(
              child: CupertinoButton(
                onPressed: () async{

                  if(await canLaunch(url))
                  {
                    await launch(url, forceSafariVC: true,
                      forceWebView: true,);
                  } else{makeDialog('브라우저에서 $url 열기 실패!');}
                },

                child: Text(
                  '  * 항목에 대한 정보(출처) 확인하기(클릭)*\n'
                      '           -sources of the information-',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height/50,
          ),

          Container(
            //color: Colors.brown[200],
            height: 400,
            child: Center(
              child: ListView.separated(
                padding: const EdgeInsets.only(left:15.0, right:15.0, top:0.0, bottom: 5.0),
                separatorBuilder: (context, position) => Divider(height: 5,),
                itemBuilder: (context, position) {
                  return Container(
                    color: Colors.brown[100],
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                              child: Text(
                            _checkCards[position].quary,
                                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                          )),
                          CupertinoSwitch(
                            value: _checkCards[position].isChecked,
                            onChanged: (value) {
                              setState(() {
                                _checkCards[position].isChecked = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                    );
                 // );
                },
                itemCount: _checkCards.length,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/5,
              child: CupertinoButton(
                  borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  child: Text(
                    '제      출',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.white, ),
                  ),
                  color: Colors.brown[900],
                  onPressed: () {

                    _dbRefComnameDate = _database
                        .reference()
                        .child(userComName)
                        .child('$_year$_month$_day');

                    _dbRefComnameDate
                        .child(id)
                        .update
                      (CheckList(
                          id,
                          DateTime.now().toIso8601String(),
                          userName,
                          userPlace,
                          userComName,
                          _checkCards[0].isChecked,
                          _checkCards[1].isChecked,
                          _checkCards[2].isChecked,
                          _checkCards[3].isChecked,
                          _checkCards[4].isChecked,
                          _checkCards[5].isChecked,
                          _checkCards[6].isChecked,
                          true, //금일 체크 했는지
                        ).toJson())
                        .then((_) {
                      _database
                          .reference()
                          .child(userComName)
                          .child('notification')
                          .onValue.listen((event) {
                        _comNotifyData = NotiComData.fromSnapshot(event.snapshot);
                        _isNoti =_comNotifyData.isPut;
                        if(_isNoti)
                        {
                          makeDialog2(_comNotifyData.content,title:_comNotifyData.title);
                        }
                        else{
                          makeDialog3('금일 자가체크 등록이 완료되었습니다.\n 조금이라도 이상이 있으면 즉시 회사로 연락바랍니다.','감사합니다','/intro',user);
                        }
                      });
                    });

                  }),
            ),
          ),

          // Container(
          //   height: 50,
          //   child: Center(
          //     child:TextButton(
          //       child: Text('나의예약일자: 1차($userReservFirst), 2차($userReservSecond)', style: TextStyle(fontSize: 18,color: Colors.black),),
          //     ),
          //   ),
          // ),
          //
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: 50,
          //     child: CupertinoButton(
          //         borderRadius: const BorderRadius.all(Radius.circular(0.0)),
          //         child: Text(
          //           '예약 일자 등록',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: 18, color: Colors.black, ),
          //         ),
          //         color: Colors.limeAccent,
          //         onPressed: () {
          //
          //
          //           _database
          //               .reference()
          //               .child(userComName)
          //               .child('user')
          //               .child(id)
          //               .onChildAdded
          //               .listen((event) {
          //             //user에서 예약날짜 가져오기
          //             String _testReservationFirstDate = (event.snapshot.value['reservationFirst']==null) ? '' : event.snapshot.value['reservationFirst'];
          //             String _testReservationSecondDate = (event.snapshot.value['reservationSecond']==null) ? '' : event.snapshot.value['reservationSecond'];
          //
          //             if(_testReservationFirstDate=='' &&_testReservationSecondDate=='')
          //             {
          //               makeDialog3('지금 등록페이지로 이동하시겠습니까?','예약등록','/ReservationFirst',user);
          //             }
          //             else{
          //               makeDialog3('1차 혹은 2차 예약을 하신 적이 있습니다.\n 지금 "기존 등록확인" 혹은 "수정등록"을 하기 위해 페이지로 이동하시겠습니까?','수정등록','/ReservationFirst',user);
          //             }
          //           });
          //
          //           // makeDialog('감사합니다.\n금일 자가검진 등록이 완료되었습니다2.');
          //
          //           // Navigator.of(context).pop();
          //         }),
          //   ),
          // ),

        ],
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

  void makeDialog2(String text, {String title}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title==null?'':title),
            content: Text(text),
            actions: <Widget>[
              new CupertinoButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/intro');

                },
              ),
            ],
          );
        }

        );
  }

  void makeDialog3(String text, String title, String rName, User user) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title==null?'':title),
            content: Text(text),
            actions: <Widget>[
              new CupertinoButton(

                //yes or no
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(rName,
                      arguments: user);
                },
              ),

              new CupertinoButton(

                //yes or no
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }

    );
  }

}
