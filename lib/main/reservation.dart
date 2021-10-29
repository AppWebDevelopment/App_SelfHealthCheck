import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/user.dart';
import 'package:selfchecker/data/reservationData.dart';
import 'package:selfchecker/enum.dart';
import 'package:selfchecker/data/reservationData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  FirebaseDatabase _database;
  DatabaseReference _dbRefComnameUserDate;
  DatabaseReference _dbRefComnameReservationFirstDate;
  DatabaseReference _dbRefComnameReservationSecondDate;
  DatabaseReference _dbRefComNofi;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';

  var _year = DateTime.now().year;
  var _month = DateTime.now().month;
  var _day = DateTime.now().day;

  int bookLimitNum = 0;
  int noRePeatFirstSecond = 0;

  String ReservationFirstDate;
  String ReservationSecondDate;

  List<bool> isSelected = <bool>[false, false, false, false, false];

  String _selectedHour1 = '0';
  String _selectedHour2 = '0';

  SharedPreferences _pref;

  String _savedReservationM1 = '';
  String _savedReservationM2 = '';
  String _savedReservationD1 = '';
  String _savedReservationD2 = '';
  String _savedReservationH1 = '';
  String _savedReservationH2 = '';
  String _savedReservationKind = '';
  int _savedReservationDate1 = 9;
  int _savedReservationDate2 = 9;

  String _reservationM1 = '';
  String _reservationM2 = '';
  String _reservationD1 = '';
  String _reservationD2 = '';
  String _reservationH1 = '';
  String _reservationH2 = '';
  String _reservationKind = '';
  int _reservationDate1 = 9;
  int _reservationDate2 = 9;

  List<String> noBookingDateList = [];
  String monthlyOverBookDayTotal = '';
  bool isBookOverGlobal = false;

  //bool isBookOverGlobal2 = false;
  bool isBookOverMyMonth = false;

  void _innerLoadData(EnumPrefKey e) async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      switch (e) {
        case EnumPrefKey.ReservationKind:
          var value = _pref.getString(EnumPrefKey.ReservationKind.toString());
          _savedReservationKind = (value == null) ? "" : value;
          _reservationKind = _savedReservationKind;
          break;
        case EnumPrefKey.ReservationM1:
          var value = _pref.getString(EnumPrefKey.ReservationM1.toString());
          _savedReservationM1 = (value == null) ? "" : value;
          _reservationM1 = _savedReservationM1;
          break;
        case EnumPrefKey.ReservationM2:
          var value = _pref.getString(EnumPrefKey.ReservationM2.toString());
          _savedReservationM2 = (value == null) ? "" : value;
          _reservationM2 = _savedReservationM2;
          break;
        case EnumPrefKey.ReservationD1:
          var value = _pref.getString(EnumPrefKey.ReservationD1.toString());
          _savedReservationD1 = (value == null) ? "" : value;
          _reservationD1 = _savedReservationD1;
          break;
        case EnumPrefKey.ReservationD2:
          var value = _pref.getString(EnumPrefKey.ReservationD2.toString());
          _savedReservationD2 = (value == null) ? "" : value;
          _reservationD2 = _savedReservationD2;
          break;
        case EnumPrefKey.ReservationH1:
          var value = _pref.getString(EnumPrefKey.ReservationH1.toString());
          _savedReservationH1 = (value == null) ? "" : value;
          _reservationH1 = _savedReservationH1;
          break;
        case EnumPrefKey.ReservationH2:
          var value = _pref.getString(EnumPrefKey.ReservationH2.toString());
          _savedReservationH2 = (value == null) ? "" : value;
          _reservationH2 = _savedReservationH2;
          break;
        case EnumPrefKey.ReservationDate1:
          var value = _pref.getInt(EnumPrefKey.ReservationDate1.toString());
          _savedReservationDate1 = (value == null) ? 9 : value;
          _reservationDate1 = _savedReservationDate1;
          break;
        case EnumPrefKey.ReservationDate2:
          var value = _pref.getInt(EnumPrefKey.ReservationDate2.toString());
          _savedReservationDate2 = (value == null) ? 9 : value;
          _reservationDate2 = _savedReservationDate2;
          break;
      }
    });
  }

  void _innerSaveData(EnumPrefKey e, var value) async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      switch (e) {
        case EnumPrefKey.ReservationKind:
          _pref.setString(EnumPrefKey.ReservationKind.toString(), value);
          break;
        case EnumPrefKey.ReservationM1:
          _pref.setString(EnumPrefKey.ReservationM1.toString(), value);
          break;
        case EnumPrefKey.ReservationM2:
          _pref.setString(EnumPrefKey.ReservationM2.toString(), value);
          break;
        case EnumPrefKey.ReservationD1:
          _pref.setString(EnumPrefKey.ReservationD1.toString(), value);
          break;
        case EnumPrefKey.ReservationD2:
          _pref.setString(EnumPrefKey.ReservationD2.toString(), value);
          break;
        case EnumPrefKey.ReservationH1:
          _pref.setString(EnumPrefKey.ReservationH1.toString(), value);
          break;
        case EnumPrefKey.ReservationH2:
          _pref.setString(EnumPrefKey.ReservationH2.toString(), value);
          break;
        case EnumPrefKey.ReservationDate1:
          _pref.setInt(EnumPrefKey.ReservationDate1.toString(), value);
          break;
        case EnumPrefKey.ReservationDate2:
          _pref.setInt(EnumPrefKey.ReservationDate2.toString(), value);
          break;
      }
    });
  }

  void initState() {
    super.initState();

    _database = FirebaseDatabase(databaseURL: _databaseURL);

    //_reservationData = new ReservationData('','','','','',0,0,0,0,0,0);
    //_reservationData = new ReservationData('','','','','','','','','','','');

    _innerLoadData(EnumPrefKey.ReservationKind);
    _innerLoadData(EnumPrefKey.ReservationM1);
    _innerLoadData(EnumPrefKey.ReservationM2);
    _innerLoadData(EnumPrefKey.ReservationD1);
    _innerLoadData(EnumPrefKey.ReservationD2);
    _innerLoadData(EnumPrefKey.ReservationH1);
    _innerLoadData(EnumPrefKey.ReservationH2);
    _innerLoadData(EnumPrefKey.ReservationDate1);
    _innerLoadData(EnumPrefKey.ReservationDate2);
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    final String id = user.id;
    final String userComName = user.userCompanyName;
    final String userName = user.username;
    final String userPlace = user.userplace;

    _database
        .reference()
        .child(userComName)
        .child('notification')
        .onValue
        .listen((event) {
      bookLimitNum = event.snapshot.value['bookNum'];
      print('bookLimitNum:$bookLimitNum');
    });

    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.teal[800],
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/intro',arguments: user);
          },
        ),
        middle: Text(
          '예약 일자 등록(수정 등록)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[100],
      ),
      backgroundColor: Colors.teal[50],
      body: ListView(
        children: <Widget>[
          // SizedBox(
          //   height: 5,
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Center(
              child: TextButton(
                child: Text(
                  '"수정등록" 경우 날짜수정 후 "02-773-0808" 로 반드시 연락주십시요',
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  child: Text(
                    '(1)예약종류 선택 → ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ),
                ToggleButtons(
                  color: Colors.black87,
                  disabledColor: Colors.teal,
                  selectedColor: Colors.white,
                  selectedBorderColor: Colors.deepPurple,
                  fillColor: Colors.teal[300],
                  splashColor: Colors.blue,
                  hoverColor: Colors.orange,
                  borderRadius: BorderRadius.circular(4.0),
                  constraints: BoxConstraints(minHeight: 36.0),
                  isSelected: isSelected,
                  onPressed: (index) {
                    isSelected = <bool>[false, false, false, false, false];

                    switch (index) {
                      case 0:
                        _reservationKind = 'A';
                        break;
                      case 1:
                        _reservationKind = 'H';
                        break;
                      case 2:
                        _reservationKind = 'M';
                        break;
                      case 3:
                        _reservationKind = 'Y';
                        break;
                      case 4:
                        _reservationKind = 'E';
                        break;
                      default:
                        _reservationKind = '';
                    }

                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('A'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('H'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('M'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Y'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('기타'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.12,
                      height: 50,
                      child: CupertinoButton(
                        borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021, 5),
                            lastDate: DateTime(2022, 5),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child,
                              );
                            },
                          );
                          selectedDate.then(
                            (dateTime) {
                              setState(() {
                                _reservationM1 = dateTime.month.toString();
                                _reservationD1 = dateTime.day.toString();
                                _reservationDate1 = dateTime.weekday;
                                print(_reservationDate1);

                                if (_reservationM1.length == 1) {
                                  _reservationM1 = '0' + _reservationM1;
                                }
                                if (_reservationD1.length == 1) {
                                  _reservationD1 = '0' + _reservationD1;
                                }

                                //makedialog
                              });
                            },
                          );
                        },
                        color: Colors.teal[300],
                        child: Text(
                          '(2)1차날짜선택',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.12,
                      height: 50,
                      child: CupertinoButton(
                        borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          selectedTime.then(
                            (timeOfDay) {
                              setState(() {
                                _reservationH1 = timeOfDay.hour.toString();
                                if (_reservationH1.length == 1) {
                                  _reservationH1 = '0' + _reservationH1;
                                }
                              });
                            },
                          );
                        },
                        color: Colors.teal[300],
                        child: Text(
                          '(3)1차시간선택',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                  '나의 1차 일자: ($_reservationKind) $_reservationM1월 $_reservationD1일 $_reservationH1시'),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, bottom: 5.0, top: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CupertinoButton(
                      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                      child: Text(
                        '(4)1차 일자 등록완료하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.teal[900],
                      onPressed: () async {
                        noRePeatFirstSecond = 0;
                        if (_reservationKind == '') {
                          await makeDialog('예약종류가 선택되지 않았습니다. 선택해주시기 바랍니다.');
                        } else if (_reservationM1 == '' ||
                            _reservationD1 == '' ||
                            _reservationH1 == '' ||
                            _reservationDate1 == 9) {
                          await makeDialog(
                              '날짜 혹은 시간 등록이 되지 않았습니다. 날짜와 시간 모두 선택하고 등록하시기  바랍니다.');
                        } else {
                          _innerSaveData(
                              EnumPrefKey.ReservationKind, _reservationKind);
                          _innerSaveData(
                              EnumPrefKey.ReservationM1, _reservationM1);
                          _innerSaveData(
                              EnumPrefKey.ReservationD1, _reservationD1);
                          _innerSaveData(
                              EnumPrefKey.ReservationH1, _reservationH1);
                          _innerSaveData(
                              EnumPrefKey.ReservationDate1, _reservationDate1);

                          _dbRefComnameReservationFirstDate = _database
                              .reference()
                              .child(userComName)
                              .child('firstReservation');

                          _dbRefComnameReservationSecondDate = _database
                              .reference()
                              .child(userComName)
                              .child('secondReservation');

                          int removeCount = 0;
                          int messageCount1 = 0;
                          int messageCount2 = 0;
                          print('aa');

                          await isOverBook(
                              _dbRefComnameReservationFirstDate,
                              _dbRefComnameReservationSecondDate,
                              _reservationM1,
                              _reservationD1,
                              _reservationDate1,
                              false);

                          print('ff');

                          //기존 예약날짜에 있는 예약 데이터 user에서 가져와서 지우기
                          _database
                              .reference()
                              .child(userComName)
                              .child('user')
                              .child(id)
                              .child(user.key)
                              .onValue
                              .listen((event) async {
                            if (noRePeatFirstSecond == 0) {
                              print('gg');
                              //user에서 예약날짜 가져오기
                              String _testReservationFirstDate = (event
                                          .snapshot.value['reservationFirst'] ==
                                      null)
                                  ? ''
                                  : event.snapshot.value['reservationFirst'];

                              if (_testReservationFirstDate == '') {
                                print('hh');
                              } else {
                                print('ii');

                                if (isBookOverGlobal) {
                                  print('jj');
                                } else {
                                  print('kk');
                                  //해당 날짜에 있는 아이디 지우기
                                  if (removeCount == 0) {
                                    _dbRefComnameReservationFirstDate
                                        .child(_testReservationFirstDate)
                                        .child(id)
                                        .remove();
                                    removeCount++;
                                  }
                                }
                              }

                              print('ll');

                              if (isBookOverGlobal) {
                                print('mm');
                                if (messageCount1 == 0) {
                                  print('oo');
                                  messageCount1++;
                                  await makeDialog(
                                      '현재 선택하신 날짜는 대직지원 가능 인원 초과로 마감되었습니다. 아래 "예약불가일자"를 확인하시고 다른 날짜로 예약해주시기 바랍니다.');
                                }
                              } else {
                                print('pp');
                                user.reservationFirst =
                                    '$_reservationM1$_reservationD1';

                                //user에 데이터 업데이트 하기
                                _database
                                    .reference()
                                    .child(userComName)
                                    .child('user')
                                    .child(id)
                                    .child(user.key)
                                    .update(user.toJsonReservation1());

                                print('qq');
                                //reservationData에 업데이트하기
                                _dbRefComnameReservationFirstDate
                                    .child('$_reservationM1$_reservationD1')
                                    .child(id)
                                    .update(ReservationData(
                                            id,
                                            _reservationKind,
                                            '$_reservationM1$_reservationD1',
                                            '$_reservationH1',
                                            userName,
                                            userPlace,
                                            '1차')
                                        .toJson())
                                    .then((_) async {
                                  print('rr');
                                  if (messageCount2 == 0) {
                                    messageCount2++;
                                    await makeDialog(
                                        '1차 일자 등록이 완료되었습니다. 2차 일자도 등록해주시기 바랍니다.');
                                  }
                                });
                              }
                              noRePeatFirstSecond++;
                              print('ss');
                            }
                          }); //aa
                        }
                      }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.12,
                      height: 50,
                      child: CupertinoButton(
                        borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021, 5),
                            lastDate: DateTime(2022, 5),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child,
                              );
                            },
                          );
                          selectedDate.then(
                            (dateTime) {
                              setState(() {
                                _reservationM2 = dateTime.month.toString();
                                _reservationD2 = dateTime.day.toString();
                                _reservationDate2 = dateTime.weekday;

                                if (_reservationM2.length == 1) {
                                  _reservationM2 = '0' + _reservationM2;
                                }
                                if (_reservationD2.length == 1) {
                                  _reservationD2 = '0' + _reservationD2;
                                }

                                //makedialog
                              });
                            },
                          );
                        },
                        color: Colors.teal[400],
                        child: Text(
                          '(5)2차날짜선택',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.12,
                      height: 50,
                      child: CupertinoButton(
                        borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          selectedTime.then(
                            (timeOfDay) {
                              setState(() {
                                _reservationH2 = timeOfDay.hour.toString();
                                if (_reservationH2.length == 1) {
                                  _reservationH2 = '0' + _reservationH2;
                                }
                              });
                            },
                          );
                        },
                        color: Colors.teal[400],
                        child: Text(
                          '(6)2차시간선택',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                  '나의 2차 일자: ($_reservationKind) $_reservationM2월 $_reservationD2일 $_reservationH2시'),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, bottom: 5.0, top: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CupertinoButton(
                      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                      child: Text(
                        '(7)2차 일자 등록완료하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.teal[900],
                      onPressed: () async {
                        noRePeatFirstSecond = 0;
                        if (_reservationKind == '') {
                          makeDialog('예약종류가 선택되지 않았습니다. 선택해주시기 바랍니다.');
                        } else if (_reservationM2 == '' ||
                            _reservationD2 == '' ||
                            _reservationH2 == '' ||
                            _reservationDate2 == 9) {
                          makeDialog(
                              '날짜 혹은 시간 등록이 되지 않았습니다. 날짜와 시간 모두 선택하고 등록하시기  바랍니다.');
                        } else {
                          _innerSaveData(
                              EnumPrefKey.ReservationKind, _reservationKind);
                          _innerSaveData(
                              EnumPrefKey.ReservationM2, _reservationM2);
                          _innerSaveData(
                              EnumPrefKey.ReservationD2, _reservationD2);
                          _innerSaveData(
                              EnumPrefKey.ReservationH2, _reservationH2);
                          _innerSaveData(
                              EnumPrefKey.ReservationDate2, _reservationDate2);

                          _dbRefComnameReservationFirstDate = _database
                              .reference()
                              .child(userComName)
                              .child('firstReservation');

                          _dbRefComnameReservationSecondDate = _database
                              .reference()
                              .child(userComName)
                              .child('secondReservation');

                          int removeCount = 0;
                          int messageCount1 = 0;
                          int messageCount2 = 0;

                          print('a');

                          await isOverBook(
                              _dbRefComnameReservationFirstDate,
                              _dbRefComnameReservationSecondDate,
                              _reservationM2,
                              _reservationD2,
                              _reservationDate2,
                              false);

                          print('isBookOverGlobal2 1:$isBookOverGlobal');
                          print('f');
                          //기존 예약날짜에 있는 예약 데이터 user에서 가져와서 지우기
                          _database
                              .reference()
                              .child(userComName)
                              .child('user')
                              .child(id)
                              .child(user.key)
                              .onValue
                              .listen((event) async {
                            if (noRePeatFirstSecond == 0) {
                              //print('isBookOverGlobal2 2:$isBookOverGlobal2');
                              print('g');
                              //user에서 예약날짜 가져오기
                              String _testReservationSecondDate = (event
                                          .snapshot
                                          .value['reservationSecond'] ==
                                      null)
                                  ? ''
                                  : event.snapshot.value['reservationSecond'];

                              if (_testReservationSecondDate == '') {
                                print('h');
                              } else {
                                print('i');
                                //print('isBookOverGlobal2 3:$isBookOverGlobal2');
                                if (isBookOverGlobal) {
                                  print('j');
                                } else {
                                  print('k');
                                  //해당 날짜에 있는 아이디 지우기
                                  if (removeCount == 0) {
                                    _dbRefComnameReservationSecondDate
                                        .child(_testReservationSecondDate)
                                        .child(id)
                                        .remove();
                                    removeCount++;
                                    print('l:$removeCount');
                                  }
                                }
                              }
                              print('m');

                              if (isBookOverGlobal) {
                                print('n');
                                if (messageCount1 == 0) {
                                  print('o');
                                  messageCount1++;
                                  await makeDialog(
                                      '현재 선택하신 날짜는 대직지원 가능 인원 초과로 마감되었습니다. 아래 "예약불가일자"를 확인하시고 다른 날짜로 예약해주시기 바랍니다.');
                                }
                              } else {
                                print('p');
                                user.reservationSecond =
                                    '$_reservationM2$_reservationD2';

                                //user에 데이터 업데이트 하기
                                _database
                                    .reference()
                                    .child(userComName)
                                    .child('user')
                                    .child(id)
                                    .child(user.key)
                                    .update(user.toJsonReservation2());

                                print('q');
                                //reservationData에 업데이트하기
                                _dbRefComnameReservationSecondDate
                                    .child('$_reservationM2$_reservationD2')
                                    .child(id)
                                    .update(ReservationData(
                                            id,
                                            _reservationKind,
                                            '$_reservationM2$_reservationD2',
                                            '$_reservationH2',
                                            userName,
                                            userPlace,
                                            '2차')
                                        .toJson())
                                    .then((_) async {
                                  print('r');
                                  if (messageCount2 == 0) {
                                    print('s');
                                    messageCount2++;
                                    makeDialog(
                                        '2차 일자 등록이 완료되었습니다. 추후 날짜 등 수정사항이 있을 경우 앱으로는 불가하오니 담당자(02-773-0808)로 전화연락주시기 바랍니다.');
                                  }
                                });
                              }
                              noRePeatFirstSecond++;
                            }
                          });
                        }
                      }),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: CupertinoButton(
                  borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  child: Text(
                    '* 예약 불가 일자 확인 ↓',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {}),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 2.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('06', userComName);
                      },
                      child: Text('6월')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, right: 2.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange[300], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('07', userComName);
                      },
                      child: Text('7월')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, right: 2.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('08', userComName);
                      },
                      child: Text('8월')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, right: 5.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange[300], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('09', userComName);
                      },
                      child: Text('9월')),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 2.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange[300], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('10', userComName);
                      },
                      child: Text('10월')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, right: 2.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('11', userComName);
                      },
                      child: Text('11월')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, right: 2.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange[300], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('12', userComName);
                      },
                      child: Text('12월')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, right: 5.0, bottom: 15.0, top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4.3,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        primary: Colors.orange, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        await findMonthlyOverBooking('01', userComName);
                      },
                      child: Text('1월')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> makeDialog(String text) async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text(text),
          );
        });
  }

  void makeDialog2(String text, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title == null ? '' : title),
            content: Text(text),
            actions: <Widget>[
              new CupertinoButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ],
          );
        });
  }

  Future<void> makeDialog3(String text, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title == null ? '' : title),
            content: Text(text),
            actions: <Widget>[
              new CupertinoButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ],
          );
        });
  }

  Future<void> findMonthlyOverBooking(
      String _month, String _userComName) async {
    noBookingDateList.clear();
    monthlyOverBookDayTotal='';

    _dbRefComnameReservationFirstDate =
        _database.reference().child(_userComName).child('firstReservation');

    _dbRefComnameReservationSecondDate =
        _database.reference().child(_userComName).child('secondReservation');

    int _day = 0;
    int _year = 2021;

    print('11111');

    if (int.parse(_month) < 5) {
      _year = 2022;
    }

    for (int i = 0; i < 31; i++) {
      print('22222');
      _day++;

      int _monthDate = DateTime(_year, int.parse(_month), _day, 1).weekday;

      String _dayString = _day.toString();

      if (_dayString.length == 1) {
        _dayString = '0' + _dayString;
      }

      await isOverBook(
          _dbRefComnameReservationFirstDate,
          _dbRefComnameReservationSecondDate,
          _month,
          _dayString,
          _monthDate,
          true);

      print('33333');
    }

    print('44444');

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (noBookingDateList.isEmpty) {
        monthlyOverBookDayTotal = '모든 날짜 예약 가능합니다';
      } else {
        noBookingDateList.forEach((element) {
          monthlyOverBookDayTotal = monthlyOverBookDayTotal + ' / ' + element;
        });
      }

      await makeDialog3(monthlyOverBookDayTotal, '$_month월 예약불가 날짜');

    });
  }

  Future<void> isOverBook(
      DatabaseReference _dR1,
      DatabaseReference _dR2,
      String _reservationMonth,
      String _reservationDay,
      int _reservationDate,
      bool isMonthNoBookingCheck) async {
    print('######');

    int ttotalBookNum =0;

    isBookOverGlobal = false;
    //isBookOverGlobal2 = false;
    isBookOverMyMonth = false;
    bool isAlreadyOverMonthBooking = false;
    String compareDate = '';

    print('aaa');

    _dR1
        .child('$_reservationMonth$_reservationDay')
        .onChildAdded
        .listen((event) async {
      print('bbb1');

      ttotalBookNum++;

      print('totalBookNum:$ttotalBookNum');
      if (_reservationDate == 6 || _reservationDate == 7) {
        print('ccc1');
        print('isBookOverGlobal1ccc: $isBookOverGlobal');
        isBookOverGlobal = false;
      } else {
        if (ttotalBookNum >= bookLimitNum) {
          print('ddd1');
          print('isBookOverGlobal1ddd: $isBookOverGlobal');
          isBookOverGlobal = true;
          if (isMonthNoBookingCheck) {
            if (!isAlreadyOverMonthBooking) {
              noBookingDateList.add('$_reservationMonth$_reservationDay');
              isAlreadyOverMonthBooking = true;
              print('monthlyOverBooking:$_reservationMonth$_reservationDay');
            }
          }
        }
      }
      print('eee1');
    });

    print('BBBBBBB');

    _dR2
        .child('$_reservationMonth$_reservationDay')
        .onChildAdded
        .listen((event) async {
      print('bbb');

      ttotalBookNum++;

      print('totalBookNum:$ttotalBookNum');

      if (_reservationDate == 6 || _reservationDate == 7) {
        print('ccc');
        print('isBookOverGlobal1ccc: $isBookOverGlobal');
        isBookOverGlobal = false;
      } else {
        if (ttotalBookNum >= bookLimitNum) {
          print('ddd');
          print('isBookOverGlobal1ddd: $isBookOverGlobal');
          isBookOverGlobal = true;
          if (isMonthNoBookingCheck) {
            if (!isAlreadyOverMonthBooking) {
              noBookingDateList.add('$_reservationMonth$_reservationDay');
              isAlreadyOverMonthBooking = true;
              print('monthlyOverBooking:$_reservationMonth$_reservationDay');
            }
          }
        }
      }
      print('eee');
    });
    print('isBookOverGlobal1Final: $isBookOverGlobal');
  }
}
