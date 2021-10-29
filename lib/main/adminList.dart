import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/listData.dart';
import 'package:selfchecker/data/listSearchDate.dart';
import 'package:selfchecker/data/checkList.dart';
import 'package:selfchecker/enum.dart';
import 'package:selfchecker/data/companyInfo.dart';


class AdminListPage extends StatefulWidget {
  DatabaseReference _dbRefComnameDate;
  DatabaseReference _dbRefComnameUserlist;
  DatabaseReference _dbRefComname;
  CompanyInfo _comInfo;

  AdminListPage(
      this._dbRefComnameDate, this._dbRefComnameUserlist, this._dbRefComname, this._comInfo);

  @override
  _AdminListPageState createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  List<DropdownMenuItem> _checkedItemListforDropMenu = List();
  List<DropdownMenuItem> _checkedDateItemListforDropMenu = List();
  List<CheckList> _totalUserList = List();
  List<CheckList> _3OvercheckerList = List();
  List<CheckList> _1OvercheckerList = List();
  List<CheckList> _checkerList = List();
  List<CheckList> _noCheckerList = List();
  List<CheckList> _screenList = List();

  EnumAdminDateCheckState _EnumState = EnumAdminDateCheckState.Over1Check;

  ScrollController _scrollController;

  int totalCount = 0;
  int checkerNum = 0;
  int unCheckerNum = 0;

  final double _spaceBtwCata = 22;

  Item _DropMenuItem;
  DateItem _DropMenuDateItem;

  Color _colorSearchDate = Colors.black12;
  Color _colorSearchChecklist = Colors.black12;
  Color _colorCheckMoreThree = Colors.deepOrangeAccent;
  Color _colorCheckOneTwo = Colors.amber[800];
  Color _colorNoAnswer = Colors.blueGrey[300];
  Color _colorAnswer = Colors.blueGrey[200];

  var _yearList = List();
  var _monthList = List();
  var _dayList = List();

  @override
  void initState() {
    super.initState();

    _checkedItemListforDropMenu.clear();
    _checkedDateItemListforDropMenu.clear();
    _screenList.clear();
    _totalUserList.clear();
    _noCheckerList.clear();

    _checkedItemListforDropMenu = CheckedItem().checkedItemList;
    _checkedDateItemListforDropMenu = CheckedDateItem().checkedItemDateList;

    _DropMenuItem = _checkedItemListforDropMenu[0].value;
    _DropMenuDateItem = _checkedDateItemListforDropMenu[0].value;

    for (int i = 14; i <= 19; i++) {
      _yearList.add(DateTime.utc(
              DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
          .year);
      _monthList.add(DateTime.utc(
              DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
          .month);
      _dayList.add(DateTime.utc(
              DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
          .day);
    }


    getUserList();
    getcheckList();
    getNoCheckData();

    if (_scrollController == null) {
      _scrollController = new ScrollController();
    }

    for (int i = 0; i < 6; i++) {
      deleteOldDatabase('${_yearList[i]}${_monthList[i]}${_dayList[i]}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacementNamed(
              '/adminIntro',
              arguments: widget._comInfo),
        ),
        centerTitle: true,
          title: Text('그룹 관리 페이지',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.lightGreen[900],
        actions: <Widget>[


          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('total: $totalCount',
            ),
          ),

              IconButton(
                icon: const Icon(CupertinoIcons.square_grid_2x2),
                tooltip: 'total user page',
                onPressed: () {
                  getTotalUserData();
                },
              ),

        ],
      ),
      //backgroundColor: Colors.brown[100],
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  DropdownButton(
                    items: _checkedDateItemListforDropMenu,
                    onChanged: (value) {
                      DateItem SeclectItem = value;
                      setState(() {
                        _DropMenuDateItem = SeclectItem;
                      });
                    },
                    value: _DropMenuDateItem,
                  ),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      onPressed: () {
                        getSortDatabase(_DropMenuDateItem.value);

                        _colorSearchDate = Colors.red;
                        _colorSearchChecklist = Colors.black12;
                        _colorCheckMoreThree = Colors.deepOrangeAccent;
                        _colorCheckOneTwo = Colors.amber[800];
                        _colorNoAnswer = Colors.blueGrey[300];
                        _colorAnswer = Colors.blueGrey[200];
                      },
                      child: Text(
                        '일자검색',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: _colorSearchDate,
                    ),
                  ),
                  DropdownButton(
                    items: _checkedItemListforDropMenu,
                    onChanged: (value) {
                      setState(() {
                        _DropMenuItem = value;
                      });
                    },
                    value: _DropMenuItem,
                  ),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      onPressed: () {
                        _EnumState = EnumAdminDateCheckState.Search;
                        _screenList.clear();

                        getSortData(_DropMenuItem.value, true);

                        _colorSearchDate = Colors.black12;
                        _colorSearchChecklist = Colors.red;
                        _colorCheckMoreThree = Colors.deepOrangeAccent;
                        _colorCheckOneTwo = Colors.amber[800];
                        _colorNoAnswer = Colors.blueGrey[300];
                        _colorAnswer = Colors.blueGrey[200];
                      },
                      child: Text(
                        '검색',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: _colorSearchChecklist,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _EnumState = EnumAdminDateCheckState.Over3Check;
                      getcheckNumOverThreeData('checknum');
                      _colorSearchDate = Colors.black12;
                      _colorSearchChecklist = Colors.black12;
                      _colorCheckMoreThree = Colors.red;
                      _colorCheckOneTwo = Colors.amber[800];
                      _colorNoAnswer = Colors.blueGrey[300];
                      _colorAnswer = Colors.blueGrey[200];
                    },
                    child: Text(
                      '위험(3~)',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: _colorCheckMoreThree,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _EnumState = EnumAdminDateCheckState.Over1Check;
                      getcheckNumOneOrTwoData('checknum');
                      _colorSearchDate = Colors.black12;
                      _colorSearchChecklist = Colors.black12;
                      _colorCheckMoreThree = Colors.deepOrangeAccent;
                      _colorCheckOneTwo = Colors.red;
                      _colorNoAnswer = Colors.blueGrey[300];
                      _colorAnswer = Colors.blueGrey[200];
                    },
                    child: Text(
                      '의심(1~2)',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: _colorCheckOneTwo,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _EnumState = EnumAdminDateCheckState.NoAnswer;
                      getcheckList();
                      getNoCheckData();
                      _colorSearchDate = Colors.black12;
                      _colorSearchChecklist = Colors.black12;
                      _colorCheckMoreThree = Colors.deepOrangeAccent;
                      _colorCheckOneTwo = Colors.amber[800];
                      _colorNoAnswer = Colors.red;
                      _colorAnswer = Colors.blueGrey[200];
                    },
                    child: Text(
                      '미응답\n  $unCheckerNum',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: _colorNoAnswer,
                  ),
                  SizedBox(
                    width: 80,
                    child: RaisedButton(
                      onPressed: () {
                        _EnumState = EnumAdminDateCheckState.Answer;
                        getcheckList();
                        _colorSearchDate = Colors.black12;
                        _colorSearchChecklist = Colors.black12;
                        _colorCheckMoreThree = Colors.deepOrangeAccent;
                        _colorCheckOneTwo = Colors.amber[800];
                        _colorNoAnswer = Colors.blueGrey[300];
                        _colorAnswer = Colors.red;
                      },
                      child: Text(
                        '응답\n$checkerNum',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: _colorAnswer,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),

              Row(
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '이름',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '장소',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(width: 13),
                  Text(
                    '시간',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '발열',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '기침',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '인후',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '호흡',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '개활',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '단활',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '주변',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),

              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    borderOnForeground: false,
                    shadowColor: Colors.white,
                    child: InkWell(
                      onLongPress: (){
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('직원정보를 삭제하시겠습니까?'),
                                  actions: [
                                    FlatButton(onPressed: (){
                                      setState(() async{

                                        dbUserRemove(index);
                                        getUserList();

                                        getTotalUserData();
                                        Navigator.of(context).pop();
                                      });
                                    }, child: Text('Ok')),
                                    FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Cancel'))
                                  ],
                                );
                              });
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 15,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Row(

                              children: <Widget>[
                                Text(
                                  (_screenList[index].name.length >= 3)
                                      ? _screenList[index].name.substring(0, 3)
                                      : _screenList[index].name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: _spaceBtwCata-5,
                                ),
                                Text(
                                  (_screenList[index].place.length >= 3)
                                      ? _screenList[index].place.substring(0, 3)
                                      : _screenList[index].place,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: _spaceBtwCata/2,
                                ),
                                Text(
                                  _screenList[index].checkTime.substring(11, 16),
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(
                                  width: _spaceBtwCata,
                                ),
                                Icon(
                                  (_screenList[index]
                                              .isFever
                                              .toString()
                                              .substring(0, 1) ==
                                          'f')
                                      ? Icons.remove
                                      : Icons.assignment_turned_in_rounded,
                                  color: (_screenList[index]
                                              .isFever
                                              .toString()
                                              .substring(0, 1) !=
                                          'f')
                                      ? Colors.red
                                      : Colors.black12,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: _spaceBtwCata,
                                ),
                                Icon(
                                    (_screenList[index]
                                                .isCough
                                                .toString()
                                                .substring(0, 1) ==
                                            'f')
                                        ? Icons.remove
                                        : Icons.assignment_turned_in_rounded,
                                    color: (_screenList[index]
                                                .isCough
                                                .toString()
                                                .substring(0, 1) !=
                                            'f')
                                        ? Colors.red
                                        : Colors.black12,
                                    size: 15),
                                SizedBox(
                                  width: _spaceBtwCata,
                                ),
                                Icon(
                                    (_screenList[index]
                                                .isThroatPain
                                                .toString()
                                                .substring(0, 1) ==
                                            'f')
                                        ? Icons.remove
                                        : Icons.assignment_turned_in_rounded,
                                    color: (_screenList[index]
                                                .isThroatPain
                                                .toString()
                                                .substring(0, 1) !=
                                            'f')
                                        ? Colors.red
                                        : Colors.black12,
                                    size: 15),
                                SizedBox(
                                  width: _spaceBtwCata
                                ),
                                Icon(
                                    (_screenList[index]
                                                .isDyspnea
                                                .toString()
                                                .substring(0, 1) ==
                                            'f')
                                        ? Icons.remove
                                        : Icons.assignment_turned_in_rounded,
                                    color: (_screenList[index]
                                                .isDyspnea
                                                .toString()
                                                .substring(0, 1) !=
                                            'f')
                                        ? Colors.red
                                        : Colors.black12,
                                    size: 15),
                                SizedBox(
                                  width: _spaceBtwCata,
                                ),
                                Icon(
                                    (_screenList[index]
                                                .isActivity
                                                .toString()
                                                .substring(0, 1) ==
                                            'f')
                                        ? Icons.remove
                                        : Icons.assignment_turned_in_rounded,
                                    color: (_screenList[index]
                                                .isActivity
                                                .toString()
                                                .substring(0, 1) !=
                                            'f')
                                        ? Colors.red
                                        : Colors.black12,
                                    size: 15),
                                SizedBox(
                                  width: _spaceBtwCata,
                                ),
                                Icon(
                                    (_screenList[index]
                                                .isGroupAct
                                                .toString()
                                                .substring(0, 1) ==
                                            'f')
                                        ? Icons.remove
                                        : Icons.assignment_turned_in_rounded,
                                    color: (_screenList[index]
                                                .isGroupAct
                                                .toString()
                                                .substring(0, 1) !=
                                            'f')
                                        ? Colors.red
                                        : Colors.black12,
                                    size: 15),
                                SizedBox(
                                  width: _spaceBtwCata,
                                ),
                                Icon(
                                    (_screenList[index]
                                                .isContact
                                                .toString()
                                                .substring(0, 1) ==
                                            'f')
                                        ? Icons.remove
                                        : Icons.assignment_turned_in_rounded,
                                    color: (_screenList[index]
                                                .isContact
                                                .toString()
                                                .substring(0, 1) !=
                                            'f')
                                        ? Colors.red
                                        : Colors.black12,
                                    size: 15),
                                //SizedBox(width: 5,),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _screenList.length,
                controller: _scrollController,
              )),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }


  //전체 사용자 리스트 구하기
  getUserList()
  {
    print('1');
     _totalUserList.clear();
    widget._dbRefComnameUserlist.onChildAdded.listen((event) {
      print('11');
      if (event.snapshot.value != null) {
        widget._dbRefComnameUserlist
            .child(event.snapshot.key)
            .onChildAdded
            .listen((event) {
          _totalUserList
              .add(CheckList.fromSnapshotDetectNochecker(event.snapshot));
          setState(() {
            print('111');
            totalCount = _totalUserList.length;
            unCheckerNum = totalCount - checkerNum;
          });
        });
      }
    });
  }

  //응답자 리스트 구하기
  getcheckList() {

    print('2');
    _checkerList.clear();
    _screenList.clear();
    checkerNum = 0;

    widget._dbRefComnameDate.onChildAdded.listen((event) {
      print('22');
      if (event.snapshot.value != null) {
        _checkerList.add(CheckList.fromSnapshot(event.snapshot));
        if(_EnumState == EnumAdminDateCheckState.Answer) {
          setState(() {
            print('222');
              _screenList.add(CheckList.fromSnapshot(event.snapshot));
          });
        }
        setState(() {
          checkerNum = _checkerList.length;
        });
      }
    });
  }


//미응답자 리스트 구하기
  Future getNoCheckData() async{
    _noCheckerList.clear();
    unCheckerNum = 0;

    print('3');

    widget._dbRefComnameDate.onValue.listen((event) {
      _noCheckerList.clear();
      if (event.snapshot.value != null) {
        for (int i = 0; i < _totalUserList.length; i++) {
          bool same = false;

          for (int j = 0; j < _checkerList.length; j++) {
            if (int.parse(_totalUserList[i].id) ==
                int.parse(_checkerList[j].id)) {
              same = true;
            }
          }
          if (!same) {
            _noCheckerList.add(_totalUserList[i]);
            same = false;
          }
        }


        print('before nocheckList: ${unCheckerNum}');
        if(_EnumState == EnumAdminDateCheckState.NoAnswer) {
          _screenList.clear();
          unCheckerNum = _noCheckerList.length;
        }

        print('nocheckList: ${_noCheckerList.length}');
        print('after nocheckList: ${unCheckerNum}');

        if(_EnumState == EnumAdminDateCheckState.NoAnswer)
          {
            print('5');
            for (int i = 0; i < _noCheckerList.length; i++) {
              setState(() {
                print('55');
                _screenList.add(_noCheckerList[i]);
                //  unCheckerNum = _noCheckerList.length;
              });
            }
          }
      }
    });
  }

  void dbUserRemove(int _index)
  {
    print('4');
    widget._dbRefComnameUserlist.child(_screenList[_index].id).remove();
  }

//지정 날짜 데이터 구하기
  void getSortDatabase(String value) {
    print('5');
    setState(() {
      widget._dbRefComnameDate = widget._dbRefComname.child(value);
      getcheckList();
      getNoCheckData();
      print('6');
    });
  }

  //지정된 날짜의 데이터 지우기
  void deleteOldDatabase(String value) {
    if (widget._dbRefComname.child(value) != null) {
      setState(() {
        print('7');
        widget._dbRefComname.child(value).remove();
      });
    }
  }

  // 체크 내용 별 리스트
  void getSortData(String value, bool check) async {
    _screenList.clear();
    bool isIn = false;

    widget._dbRefComnameDate
        .orderByChild(value)
        .equalTo(check)
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        if(_EnumState == EnumAdminDateCheckState.Search) {
          setState(() {
            _screenList.add(CheckList.fromSnapshot(event.snapshot));
            isIn = true;
          });
        }
      }
    });

    widget._dbRefComnameDate.onValue.listen((event) {
      if(_EnumState == EnumAdminDateCheckState.Search) {
        if (event.snapshot.value != null) {
          if (!isIn) {
            setState(() {
              _screenList.clear();
            });
          }
        }
      }
    });
  }

  //3개 이상 체크 구하기기
 void getcheckNumOverThreeData(String value) {
    _screenList.clear();
    bool isIn = false;
    widget._dbRefComnameDate
        .orderByChild(value)
        .startAt(3)
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        if(_EnumState == EnumAdminDateCheckState.Over3Check) {
          setState(() {
            _screenList.add(CheckList.fromSnapshot(event.snapshot));
            isIn = true;
          });
        }
      }
    });

    // widget._dbRefComnameDate.onValue.listen((event) {
    //   print('99999');
    //   if(_EnumState == EnumAdminDateCheckState.Over3Check) {
    //     if (event.snapshot.value != null) {
    //       if (!isIn) {
    //         setState(() {
    //           print('99999');
    //           _screenList.clear();
    //         });
    //       }
    //     }
    //   }
    // });
  }

  //1~2개 체크 구하기기
  void getcheckNumOneOrTwoData(String value){
    _screenList.clear();
    bool isIn = false;
    widget._dbRefComnameDate
        .orderByChild(value)
        .startAt(1)
        .endAt(2)
        .onChildAdded
        .listen((event) {
      if(_EnumState == EnumAdminDateCheckState.Over1Check) {
        if (event.snapshot.value != null) {
          setState(() {
            _screenList.add(CheckList.fromSnapshot(event.snapshot));
            isIn = true;
          });
        }
      }
    });

    // widget._dbRefComnameDate.onValue.listen((event) {
    //   print('@@@@');
    //   if(_EnumState == EnumAdminDateCheckState.Over1Check) {
    //     if (event.snapshot.value != null) {
    //       if (!isIn) {
    //         setState(() {
    //           print(_EnumState.toString());
    //           print('@@@@@');
    //           _screenList.clear();
    //         });
    //       }
    //     }
    //   }
    // });
  }

  //전체 사용자를 화면에 표시하기
  getTotalUserData() {
    _screenList.clear();
    for (int i = 0; i < _totalUserList.length; i++) {
      setState(() {
        _screenList.add(_totalUserList[i]);
      });
    }
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
