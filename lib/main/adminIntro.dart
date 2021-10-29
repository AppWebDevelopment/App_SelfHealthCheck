import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selfchecker/data/user.dart';
import 'package:selfchecker/data/companyInfo.dart';

class AdminIntroPage extends StatefulWidget {
  @override
  _AdminIntroPageState createState() => _AdminIntroPageState();
}

class _AdminIntroPageState extends State<AdminIntroPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CompanyInfo comInfo = ModalRoute.of(context).settings.arguments;
    final String comName = comInfo.comName;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.blue[900],
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/manager');
          },
        ),
        middle: Text(
          '$comName 관리자 선택화면',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue[700],
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              child: CupertinoButton(
                  borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  child: Text(
                    '자가 진단 체크 관리',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/admin', arguments: comInfo);
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              child: CupertinoButton(
                  borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  child: Text(
                    '예약 일자 관리',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        '/adminReservation',
                        arguments: comInfo);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
