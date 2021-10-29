import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/listData.dart';
import 'package:selfchecker/data/listSearchDate.dart';
import 'package:selfchecker/data/checkList.dart';
import 'package:selfchecker/data/reservationData.dart';
import 'package:selfchecker/enum.dart';
import 'package:selfchecker/data/companyInfo.dart';

class AdminReservationList extends StatefulWidget {
  DatabaseReference _dbRefComnameDate;
  DatabaseReference _dbRefComnameUser;
  DatabaseReference _dbRefComname;

  CompanyInfo _comInfo;

  AdminReservationList(this._dbRefComnameDate, this._dbRefComnameUser,
      this._dbRefComname, this._comInfo);

  @override
  _AdminReservationListState createState() => _AdminReservationListState();
}

class _AdminReservationListState extends State<AdminReservationList> {
  DatabaseReference _dbRefComnameReservationFirstDate;
  DatabaseReference _dbRefComnameReservationSecondDate;

  List<DropdownMenuItem> _checkedItemListforDropMenu = [];
  List<DropdownMenuItem> _monthDropMenu = [];

  List<List<ReservationData>> _MonthDataList = [];

  ScrollController _scrollController;
  ScrollController _scrollController2;

  int gYear = 2021;
  int gMonth = 0;
  int gDay = 0;

  //final double _spaceBtwCata = 22;

  String _DropMenuDateItem = '';

  Color _colorSearchDate = Colors.black12;
  Color _colorSearchChecklist = Colors.black12;
  Color _colorCheckMoreThree = Colors.deepOrangeAccent;
  Color _colorCheckOneTwo = Colors.amber[800];
  Color _colorNoAnswer = Colors.blueGrey[300];
  Color _colorAnswer = Colors.blueGrey[200];

  @override
  void initState() {
    super.initState();

    _checkedItemListforDropMenu.clear();
    _monthDropMenu.clear();

    _checkedItemListforDropMenu = CheckedItem().checkedItemList;

    _monthDropMenu.add(DropdownMenuItem(child: Text('6월'), value: '06'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('7월'), value: '07'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('8월'), value: '08'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('9월'), value: '09'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('10월'), value: '10'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('11월'), value: '11'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('12월'), value: '12'));
    _monthDropMenu.add(DropdownMenuItem(child: Text('1월'), value: '01'));

    _DropMenuDateItem = _monthDropMenu[0].value;

    for (int i = 0; i <= 30; i++) {
      _MonthDataList.add([]);
    }

    if (_scrollController == null) {
      _scrollController = new ScrollController();
    }

    if (_scrollController2 == null) {
      _scrollController2 = new ScrollController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed('/adminIntro', arguments: widget._comInfo),
        ),
        centerTitle: true,
        title: Text(
          '예약 현황 관리 페이지',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreen[900],
      ),
      //backgroundColor: Colors.brown[100],
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 7,
                  ),
                  DropdownButton(
                    items: _monthDropMenu,
                    onChanged: (value) {
                      String selectItem = value;
                      setState(() {
                        _DropMenuDateItem = selectItem;
                      });
                    },
                    value: _DropMenuDateItem,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: RaisedButton(
                      onPressed: () async {
                        if (int.parse(_DropMenuDateItem) < 6) {
                          gYear = 2022;
                        } else {
                          gYear = 2021;
                        }

                          gMonth = int.parse(_DropMenuDateItem);

                        setState(() {
                          getMonthlyBookingData(_DropMenuDateItem);
                        });

                        _colorSearchDate = Colors.red;
                        _colorSearchChecklist = Colors.black12;
                        _colorCheckMoreThree = Colors.deepOrangeAccent;
                        _colorCheckOneTwo = Colors.amber[800];
                        _colorNoAnswer = Colors.blueGrey[300];
                        _colorAnswer = Colors.blueGrey[200];
                      },
                      child: Text(
                        '월별검색',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: _colorSearchDate,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),

              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {

                    String _Lweekday='';

                    switch(DateTime(gYear,gMonth,index + 1).weekday)
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

                    return Card(
                      borderOnForeground: false,
                      shadowColor: Colors.white,
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 10,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context2, index2) {
                              return Card(
                                borderOnForeground: false,
                                shadowColor: Colors.white,
                                child: InkWell(
                                  onLongPress: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content:
                                                  Text('직원 예약정보를 삭제하시겠습니까?'),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      setState(() async {
                                                        String removeMonthDay =
                                                            _MonthDataList[
                                                                        index]
                                                                    [index2 - 1]
                                                                .MonthDay;
                                                        String removeId =
                                                            _MonthDataList[
                                                                        index]
                                                                    [index2 - 1]
                                                                .id;

                                                        _dbRefComnameReservationFirstDate =
                                                            widget._dbRefComname
                                                                .child(
                                                                    'firstReservation');

                                                        _dbRefComnameReservationSecondDate =
                                                            widget._dbRefComname
                                                                .child(
                                                                    'secondReservation');

                                                        if (_MonthDataList[
                                                                        index]
                                                                    [index2 - 1]
                                                                .order ==
                                                            '1차') {
                                                          dbUserReservationRemove(
                                                              _dbRefComnameReservationFirstDate,
                                                              removeMonthDay,
                                                              removeId);
                                                        } else {
                                                          dbUserReservationRemove(
                                                              _dbRefComnameReservationSecondDate,
                                                              removeMonthDay,
                                                              removeId);
                                                        }

                                                        setState(() {
                                                          getMonthlyBookingData(
                                                              _DropMenuDateItem);
                                                        });
                                                        print('final!!!!');
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text('Ok')),
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancel'))
                                              ],
                                            );
                                          });
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                (index2 == 0)
                                                    ? ''
                                                    : '${_MonthDataList[index][index2 - 1].name.substring(0, 3)}:${_MonthDataList[index][index2 - 1].order}',
                                                style: TextStyle(
                                                  color: (_MonthDataList[index]
                                                              .length >
                                                          5)
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              ),
                                              Text(
                                                (index2 == 0)
                                                    ? '${index + 1}'
                                                    : '(${_MonthDataList[index][index2 - 1].place.substring(0, 3)})',
                                                style: TextStyle(
                                                  color: (_MonthDataList[index]
                                                              .length >
                                                          5)
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              ),
                                              Text(
                                                (index2 == 0)
                                                    ? _Lweekday
                                                    : '${_MonthDataList[index][index2 - 1].kind}',
                                                style: TextStyle(
                                                  color: (_MonthDataList[index]
                                                              .length >
                                                          5)
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            },
                            //itemCount: _dayDataList.length,
                            itemCount: _MonthDataList[index].length + 1,
                            controller: _scrollController2,
                          ),

                          // children: <Widget>[
                          //   Row(
                          //     children: <Widget>[
                          //       Text(
                          //         (_dayDataList[index].name.length >= 3)
                          //             ? _dayDataList[index].name.substring(0, 3)
                          //             : _dayDataList[index].name,
                          //
                          //
                          //         style: TextStyle(
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         (_dayDataList[index].place.length >= 3)
                          //             ? '('+_dayDataList[index].place.substring(0, 3)+','
                          //             : ','+_dayDataList[index].place+')',
                          //         style: TextStyle(
                          //           fontSize: 12,
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: _spaceBtwCata/2,
                          //       ),
                          //       Text(
                          //         _dayDataList[index].checkTime.substring(11, 16),
                          //         style: TextStyle(
                          //           fontSize: 11,
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: _spaceBtwCata,
                          //       ),
                          //       Icon(
                          //         (_dayDataList[index]
                          //                     .isFever
                          //                     .toString()
                          //                     .substring(0, 1) ==
                          //                 'f')
                          //             ? Icons.remove
                          //             : Icons.assignment_turned_in_rounded,
                          //         color: (_dayDataList[index]
                          //                     .isFever
                          //                     .toString()
                          //                     .substring(0, 1) !=
                          //                 'f')
                          //             ? Colors.red
                          //             : Colors.black12,
                          //         size: 15,
                          //       ),
                          //       SizedBox(
                          //         width: _spaceBtwCata,
                          //       ),
                          //       Icon(
                          //           (_dayDataList[index]
                          //                       .isCough
                          //                       .toString()
                          //                       .substring(0, 1) ==
                          //                   'f')
                          //               ? Icons.remove
                          //               : Icons.assignment_turned_in_rounded,
                          //           color: (_dayDataList[index]
                          //                       .isCough
                          //                       .toString()
                          //                       .substring(0, 1) !=
                          //                   'f')
                          //               ? Colors.red
                          //               : Colors.black12,
                          //           size: 15),
                          //       SizedBox(
                          //         width: _spaceBtwCata,
                          //       ),
                          //       Icon(
                          //           (_dayDataList[index]
                          //                       .isThroatPain
                          //                       .toString()
                          //                       .substring(0, 1) ==
                          //                   'f')
                          //               ? Icons.remove
                          //               : Icons.assignment_turned_in_rounded,
                          //           color: (_dayDataList[index]
                          //                       .isThroatPain
                          //                       .toString()
                          //                       .substring(0, 1) !=
                          //                   'f')
                          //               ? Colors.red
                          //               : Colors.black12,
                          //           size: 15),
                          //       SizedBox(
                          //         width: _spaceBtwCata
                          //       ),
                          //       Icon(
                          //           (_dayDataList[index]
                          //                       .isDyspnea
                          //                       .toString()
                          //                       .substring(0, 1) ==
                          //                   'f')
                          //               ? Icons.remove
                          //               : Icons.assignment_turned_in_rounded,
                          //           color: (_dayDataList[index]
                          //                       .isDyspnea
                          //                       .toString()
                          //                       .substring(0, 1) !=
                          //                   'f')
                          //               ? Colors.red
                          //               : Colors.black12,
                          //           size: 15),
                          //       SizedBox(
                          //         width: _spaceBtwCata,
                          //       ),
                          //       Icon(
                          //           (_dayDataList[index]
                          //                       .isActivity
                          //                       .toString()
                          //                       .substring(0, 1) ==
                          //                   'f')
                          //               ? Icons.remove
                          //               : Icons.assignment_turned_in_rounded,
                          //           color: (_dayDataList[index]
                          //                       .isActivity
                          //                       .toString()
                          //                       .substring(0, 1) !=
                          //                   'f')
                          //               ? Colors.red
                          //               : Colors.black12,
                          //           size: 15),
                          //       SizedBox(
                          //         width: _spaceBtwCata,
                          //       ),
                          //       Icon(
                          //           (_dayDataList[index]
                          //                       .isGroupAct
                          //                       .toString()
                          //                       .substring(0, 1) ==
                          //                   'f')
                          //               ? Icons.remove
                          //               : Icons.assignment_turned_in_rounded,
                          //           color: (_dayDataList[index]
                          //                       .isGroupAct
                          //                       .toString()
                          //                       .substring(0, 1) !=
                          //                   'f')
                          //               ? Colors.red
                          //               : Colors.black12,
                          //           size: 15),
                          //       SizedBox(
                          //         width: _spaceBtwCata,
                          //       ),
                          //       Icon(
                          //           (_dayDataList[index]
                          //                       .isContact
                          //                       .toString()
                          //                       .substring(0, 1) ==
                          //                   'f')
                          //               ? Icons.remove
                          //               : Icons.assignment_turned_in_rounded,
                          //           color: (_dayDataList[index]
                          //                       .isContact
                          //                       .toString()
                          //                       .substring(0, 1) !=
                          //                   'f')
                          //               ? Colors.red
                          //               : Colors.black12,
                          //           size: 15),
                          //       //SizedBox(width: 5,),
                          //     ],
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   ),
                          // ],
                        ),
                      ),
                    );
                  },
                  //itemCount: _dayDataList.length,
                  itemCount: _MonthDataList.length,
                  controller: _scrollController,
                ),
              ),

              //Text(checkList[0].toString()),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  //응답자 리스트 구하기
  getMonthlyBookingData(String _month) async {
    _MonthDataList = [];

    for (int i = 0; i <= 30; i++) {
      _MonthDataList.add([]);
    }

    _dbRefComnameReservationFirstDate =
        widget._dbRefComname.child('firstReservation');

    _dbRefComnameReservationSecondDate =
        widget._dbRefComname.child('secondReservation');

    int _day = 0;

    print('11111');

    for (int i = 0; i < 31; i++) {
      _day++;
      print('for i start: $i   day: $_day');

      String _dayString = _day.toString();

      if (_dayString.length == 1) {
        _dayString = '0' + _dayString;
      }

      //print('middle _dayDataList: $_dayDataList');
      print('middle _MonthDataList: $_MonthDataList');

      await getMonthDailyBookingData(
        _dbRefComnameReservationFirstDate,
        _dbRefComnameReservationSecondDate,
        _month,
        _dayString,
      );

      print('for middle');

      print('for i end: $i   day: $_day');
    }

    print('66666');
  }

  Future<void> getMonthDailyBookingData(
    DatabaseReference _dR1,
    DatabaseReference _dR2,
    String _reservationMonth,
    String _reservationDay,
  ) async {
    print('aaa');

    _dR1
        .child('$_reservationMonth$_reservationDay')
        .onChildAdded
        .listen((event) async {
      print('_dR1 start: $_reservationMonth$_reservationDay');

      int tempDay = int.parse(_reservationDay);

      _MonthDataList.elementAt(tempDay - 1)
          .add(ReservationData.fromSnapshot(event.snapshot));

      print('tempDay-1: ${tempDay - 1}');
      print(
          '_MonthDataList[tempDay-1].length: ${_MonthDataList.elementAt(tempDay - 1).length}');
      print('_MonthDataList: $_MonthDataList');
      print(
          '_MonthDataList[tempDay-1]: ${_MonthDataList.elementAt(tempDay - 1)}');
      print('_dR1 end: $_reservationMonth$_reservationDay');
    });

    print('getMonthDailyBookingData middle');

    _dR2
        .child('$_reservationMonth$_reservationDay')
        .onChildAdded
        .listen((event2) async {
      print('_dR2 start: $_reservationMonth$_reservationDay');
      int tempDay = int.parse(_reservationDay);

      _MonthDataList.elementAt(tempDay - 1)
          .add(ReservationData.fromSnapshot(event2.snapshot));

      print('tempDay-1: ${tempDay - 1}');
      print(
          '_MonthDataList[tempDay-1].length: ${_MonthDataList.elementAt(tempDay - 1).length}');
      print('_MonthDataList: $_MonthDataList');
      print(
          '_MonthDataList[tempDay-1]: ${_MonthDataList.elementAt(tempDay - 1)}');
      print('_dR2 end: $_reservationMonth$_reservationDay');
    });
    print('getMonthDailyBookingData end');
  }

  dbUserReservationRemove(
      DatabaseReference _dR, String _removeMonthDay, String _removeId) {
    _dR.child(_removeMonthDay).child(_removeId).remove();
  }
}
