import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,backgroundColor: Colors.blueGrey[800], title: Text('방역 수칙',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
      body: ListView(
      children: [
        Image.asset("repo/images/img1.png", fit: BoxFit.contain),
        Image.asset("repo/images/img2.png", fit: BoxFit.contain),
        Image.asset("repo/images/img3.png", fit: BoxFit.contain),
        Image.asset("repo/images/img4.png", fit: BoxFit.contain),
        Image.asset("repo/images/img5.png", fit: BoxFit.contain),
        Image.asset("repo/images/img6.png", fit: BoxFit.contain),
        Image.asset("repo/images/img7.png", fit: BoxFit.contain),
        Image.asset("repo/images/img8.png", fit: BoxFit.contain),
        Image.asset("repo/images/img9.png", fit: BoxFit.contain),
        Image.asset("repo/images/img10.png", fit: BoxFit.contain),

      ],
    ),
    );
  }
}
