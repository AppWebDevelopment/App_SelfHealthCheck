import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:selfchecker/main/adminList.dart';
import 'package:selfchecker/main/comNofitication.dart';
import 'package:selfchecker/main/individualList.dart';
import 'package:selfchecker/data/companyInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  FirebaseDatabase _database;
  DatabaseReference _dbRefComnameDate;
  DatabaseReference _dbRefComnameUser;
  DatabaseReference _dbRefComname;
  String _databaseURL = 'https://selfcheck-1be5b-default-rtdb.firebaseio.com/';

  var _year = DateTime.now().year;
  var _month = DateTime.now().month;
  var _day = DateTime.now().day;

  CupertinoTabBar tabBar;

/*
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool pushCheck = true;

  void _loadData() async{
    var key = "push";
    SharedPreferences pref = await SharedPreferences.getInstance();
    pushCheck = pref.getBool(key);
  }
 */

  @override
  void initState() {
    super.initState();

    tabBar = CupertinoTabBar(items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_grid_4x3_fill)),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_stack_3d_down_right)),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.text_bubble)),
    ]);

    _database = FirebaseDatabase(databaseURL: _databaseURL);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CompanyInfo comInfo = ModalRoute.of(context).settings.arguments;
    
    _dbRefComnameDate = _database
        .reference()
        .child(comInfo.comName)
        .child('$_year$_month$_day');
    
    _dbRefComnameUser =
        _database.reference().child(comInfo.comName).child('user');
    
    _dbRefComname = _database.reference().child(comInfo.comName);

    return CupertinoTabScaffold(
      tabBar: tabBar,
      tabBuilder: ((context, value){
        if(value==0)
          {return AdminListPage(_dbRefComnameDate, _dbRefComnameUser, _dbRefComname, comInfo);}
        else if(value==1)
          {return IndividualPage( _dbRefComnameUser, _dbRefComname);}
        else{
          return ComNotification( _dbRefComname);
        }
      }),

    );
  }
}
