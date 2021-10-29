import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/user.dart';

class AdminReservationIndividualPage extends StatefulWidget {
  DatabaseReference _dbRefComnameUser;
  DatabaseReference _dbRefComname;

  AdminReservationIndividualPage(this._dbRefComnameUser, this._dbRefComname);

  @override
  _AdminReservationIndividualPageState createState() =>
      _AdminReservationIndividualPageState();
}

class _AdminReservationIndividualPageState
    extends State<AdminReservationIndividualPage> {
  //List<CheckList> _userPeriodCheckList = [];
  List<User> _totalBasicList = [];

  //ScrollController _scrollController;
  TextEditingController _userSearchByNameTextController;
  TextEditingController _userSearchByPhoneNumTextController;

  String userReservFirst = '';
  String userReservSecond = '';
  String userReservFirstWeekday ='';
  String userReservSecondWeekday ='';

  String userID = '';
  String userName = '';
  String userPlace = '';

  //List<int> checkedNumList = [];

  //var _yearList = [];
  //var _monthList = [];
  //var _dayList = [];

  final double _spaceBtwCata = 33;

  @override
  void initState() {
    super.initState();

    _userSearchByNameTextController = TextEditingController();
    _userSearchByPhoneNumTextController = TextEditingController();
    //_userPeriodCheckList.clear();
    _totalBasicList.clear();

    // for (int i = 0; i < 7; i++) {
    //   _yearList.add(DateTime.utc(
    //           DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
    //       .year);
    //   _monthList.add(DateTime.utc(
    //           DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
    //       .month);
    //   _dayList.add(DateTime.utc(
    //           DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
    //       .day);
    // }

    widget._dbRefComnameUser.onChildAdded.listen((event) async {
      if (event.snapshot.value != null) {
        widget._dbRefComnameUser
            .child(event.snapshot.key)
            .onChildAdded
            .listen((event2) {
          setState(() {
            _totalBasicList.add(User.fromSnapshot(event2.snapshot));
          });
        });
      }
    });

    // if (_scrollController == null) {
    //   _scrollController = new ScrollController();
    // }
    // for (int i = 0; i < 8; i++) {
    //   checkedNumList.add(0);
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _userSearchByNameTextController.dispose();
    _userSearchByPhoneNumTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '개인별 예약 일자 관리',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _userSearchByNameTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '직원 이름으로 검색',
                      labelText: '직원 이름',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 100,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        getUserReservationDay(
                            _userSearchByNameTextController.value.text);
                      });
                    },
                    child: Text(
                      '이름검색',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black12,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _userSearchByPhoneNumTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '직원 전번으로 검색(뒷4자리)',
                      labelText: '전번(뒷4자리)',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 100,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        getUserReservationDay(
                            _userSearchByPhoneNumTextController.value.text);
                      });
                    },
                    child: Text(
                      '전번검색',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black12,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                //color: Colors.blue[700],
                //height: MediaQuery.of(context).size.height / 5,
                child: Center(
                  child: TextButton(
                    child: Text(
                      '현재 $userName($userPlace) 예약일자 \n1차: $userReservFirst($userReservFirstWeekday) \n2차:$userReservSecond($userReservSecondWeekday)',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
          //mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }


  void getUserReservationDay(String userData) {
    userID = '';
    userName = '';
    userPlace = '';
    userReservFirst = '';
    userReservSecond = '';
    userReservFirstWeekday ='';
    userReservSecondWeekday ='';

    for (int i = 0; i < _totalBasicList.length; i++) {
      if (_totalBasicList[i].username == userData ||
          _totalBasicList[i].id.substring(_totalBasicList[i].id.length - 4) ==
              userData) {
        userID = _totalBasicList[i].id;
        userName = _totalBasicList[i].username;
        userPlace = _totalBasicList[i].userplace;
        userReservFirst = _totalBasicList[i].reservationFirst;
        userReservSecond = _totalBasicList[i].reservationSecond;

        userReservFirstWeekday = getWeekday( userReservFirst);
        userReservSecondWeekday = getWeekday( userReservSecond);

        break;
      } else {
        userID = '　　　　　　　　';
        userName = '　　　';
        userPlace = '　　　';
        userReservFirst = '　　　　';
        userReservSecond = '　　　　';
      }
    }
  }

  String getWeekday(String _monthDay)
  {
    int _year = 2021;

    int _month = int.parse(_monthDay.substring(0,2));
    int _day = int.parse(_monthDay.substring(_monthDay.length-2));

    if (_month < 6) {
      _year = 2022;
    }

    String _Lweekday='';

    switch(DateTime(_year,_month,_day).weekday)
    {
      case 1:
        _Lweekday = '월요일';
        break;
      case 2:
        _Lweekday = '화요일';
        break;
      case 3:
        _Lweekday = '수요일';
        break;
      case 4:
        _Lweekday = '목요일';
        break;
      case 5:
        _Lweekday = '금요일';
        break;
      case 6:
        _Lweekday = '토요일';
        break;
      case 7:
        _Lweekday = '일요일';
        break;
      default:
        break;
    }

    return _Lweekday;

  }
}
