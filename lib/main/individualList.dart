import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/checkList.dart';

class IndividualPage extends StatefulWidget {
  DatabaseReference _dbRefComnameUserlist;
  DatabaseReference _dbRefComname;

  IndividualPage(
       this._dbRefComnameUserlist, this._dbRefComname);

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  List<CheckList> _userPeriodCheckList = [];
  List<CheckList> _totalBasicList = [];
  ScrollController _scrollController;
  TextEditingController _userSearchTextController;

  List<int> checkedNumList = [];

  var _yearList = [];
  var _monthList = [];
  var _dayList = [];

  final double _spaceBtwCata = 33;

  @override
  void initState() {
    super.initState();

    _userSearchTextController = TextEditingController();
    _userPeriodCheckList.clear();
    _totalBasicList.clear();


    for (int i = 0; i < 7; i++) {
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


    widget._dbRefComnameUserlist.onChildAdded.listen((event) async {
      if (event.snapshot.value != null) {
        widget._dbRefComnameUserlist
            .child(event.snapshot.key)
            .onChildAdded
            .listen((event2) {
          setState(() {
            _totalBasicList
                .add(CheckList.fromSnapshotDetectNochecker(event2.snapshot));
          });
        });
      }
    });

    if (_scrollController == null) {
      _scrollController = new ScrollController();
    }
    for (int i = 0; i < 8; i++) {
      checkedNumList.add(0);
    }
  }

  @override
  void dispose(){
    super.dispose();
    _userSearchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text('개인별 관리 페이지',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.brown,
      ),

      body: Container(


        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _userSearchTextController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '직원 이름으로 검색',
                        labelText: '이름',
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
                        getUserPeriodData(_userSearchTextController.value.text);
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
                height: 20,
              ),

              Row(
                children: <Widget>[
                  Text(
                    '전체${checkedNumList[7]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                    ,color: (checkedNumList[7]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '발열${checkedNumList[0]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[0]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '기침${checkedNumList[1]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[1]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '인후${checkedNumList[2]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[2]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '호흡${checkedNumList[3]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[3]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '개활${checkedNumList[4]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[4]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '단활${checkedNumList[5]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[5]>0)?Colors.red:Colors.black26),
                  ),
                  Text(
                    '접촉${checkedNumList[6]}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold
                        ,color: (checkedNumList[6]>0)?Colors.red:Colors.black26),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),


              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      child: Container(
                        height: 15,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                        Row(
                        children: <Widget>[
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              _userPeriodCheckList[index]
                                  .checkTime
                                  .substring(5, 10),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: _spaceBtwCata-13,
                            ),
                          Icon(
                            (_userPeriodCheckList[index]
                                .isFever
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isFever
                                .toString()
                                .substring(0, 1) !=
                                'f')
                                ? Colors.red
                                : Colors.black12,
                            size: 20,
                          ),

                            SizedBox(
                              width: _spaceBtwCata,
                            ),
                          Icon(
                            (_userPeriodCheckList[index]
                                .isCough
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isCough
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
                            (_userPeriodCheckList[index]
                                .isThroatPain
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isThroatPain
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
                            (_userPeriodCheckList[index]
                                .isDyspnea
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isDyspnea
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
                            (_userPeriodCheckList[index]
                                .isActivity
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isActivity
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
                            (_userPeriodCheckList[index]
                                .isGroupAct
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isGroupAct
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
                            (_userPeriodCheckList[index]
                                .isContact
                                .toString()
                                .substring(0, 1) ==
                                'f')
                                ? Icons.remove
                                : Icons.assignment_turned_in_rounded,
                            color: (_userPeriodCheckList[index]
                                .isContact
                                .toString()
                                .substring(0, 1) !=
                                'f')
                                ? Colors.red
                                : Colors.black12,
                            size: 15,
                          ),

                        ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _userPeriodCheckList.length,
                controller: _scrollController,
              )),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),



    );
  }

  void getOldDataReference(String value, String userID) async {
    if (widget._dbRefComname.child(value).child(userID).key != null) {
      widget._dbRefComname
          .child(value)
          .child(userID)
          .onValue
          .listen((event) async {

        if (event.snapshot.value != null) {
          setState(() {
            _userPeriodCheckList.add(CheckList.fromSnapshot(event.snapshot));

            if (CheckList.fromSnapshot(event.snapshot).isFever == true) {
              checkedNumList[0]++;
              checkedNumList[7]++;
            }
            if (CheckList.fromSnapshot(event.snapshot).isCough == true) {
              checkedNumList[1]++;
              checkedNumList[7]++;
            }
            if (CheckList.fromSnapshot(event.snapshot).isThroatPain == true) {
              checkedNumList[2]++;
              checkedNumList[7]++;
            }
            if (CheckList.fromSnapshot(event.snapshot).isDyspnea == true) {
              checkedNumList[3]++;
              checkedNumList[7]++;
            }
            if (CheckList.fromSnapshot(event.snapshot).isActivity == true) {
              checkedNumList[4]++;
              checkedNumList[7]++;
            }
            if (CheckList.fromSnapshot(event.snapshot).isGroupAct == true) {
              checkedNumList[5]++;
              checkedNumList[7]++;
            }
            if (CheckList.fromSnapshot(event.snapshot).isContact == true) {
              checkedNumList[6]++;
              checkedNumList[7]++;
            }
          });
        }
      });
    }
  }

  void getUserPeriodData(String userData) {
    for (int i = 0; i < 8; i++) {
      checkedNumList[i]=0;
    }

    String userID;

    for (int i = 0; i < _totalBasicList.length; i++) {
      if (_totalBasicList[i].name == userData) {
        userID = _totalBasicList[i].id;
        break;
      } else {
        userID = null;
      }
    }

    setState(() {
      _userPeriodCheckList.clear();
    });

    if (userID != null) {

      for(int i=0; i<7; i++)
        {
          getOldDataReference('${_yearList[i]}${_monthList[i]}${_dayList[i]}', userID);
        }
    }
  }
}
