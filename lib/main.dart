import 'package:flutter/material.dart';
import 'package:selfchecker/signPage.dart';
import 'package:selfchecker/login.dart';
import 'login.dart';
import 'package:selfchecker/main/check.dart';
import 'package:selfchecker/main/reservation.dart';
import 'package:selfchecker/main/info.dart';
import 'package:selfchecker/main/adminReservationMain.dart';
import 'package:selfchecker/main/admin.dart';
import 'package:selfchecker/main/developerPage.dart';
import 'package:selfchecker/managerLogin.dart';
import 'package:selfchecker/main/policy.dart';
import 'package:selfchecker/main/intro.dart';
import 'package:selfchecker/main/adminIntro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'selfchecker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //fontFamily: 'NanumGothic',
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/sign': (context) => SignPage(),
        '/check': (context) => CheckPage(),
        '/ReservationFirst': (context) => ReservationPage(),
        '/info': (context) => InfoPage(),
        '/admin': (context) => AdminPage(),
        '/adminReservation': (context) => AdminReservationMainPage(),
        '/develop': (context) => DeveloperPage(),
        '/manager': (context) => ManagerPage(),
        '/policy': (context) => PolicyPage(),
        '/intro': (context) => IntroPage(),
        '/adminIntro': (context) => AdminIntroPage(),
      },
    );
  }
}

