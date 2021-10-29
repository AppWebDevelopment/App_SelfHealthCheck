import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selfchecker/data/user.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    final String id = user.id;
    final String userName = user.username;
    final String userPlace = user.userplace;
    final String userComName = user.userCompanyName;
    final String userReservFirst =
        (user.reservationFirst == null) ? '미정' : user.reservationFirst;
    final String userReservSecond =
        (user.reservationSecond == null) ? '미정' : user.reservationSecond;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.blue[900],
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        middle: Text(
          ' $userComName / $userName님 선택화면',
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
                    '자가 진단 체크',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/check', arguments: user);
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
                    '예약 일자 등록',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        '/ReservationFirst',
                        arguments: user);
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              color: Colors.blue[700],
              height: 50,
              child: Center(
                child: TextButton(
                  child: Text(
                    '현재 나의예약일자: 1차($userReservFirst), 2차($userReservSecond)',
                    style: TextStyle(fontSize: 15, color: Colors.blue[100]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
