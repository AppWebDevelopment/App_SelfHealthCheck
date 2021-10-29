import 'package:flutter/material.dart';

class PolicyPage extends StatefulWidget {
  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle:true,backgroundColor: Colors.blueGrey[800], title: Text('이용 약관',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
      body: ListView(
        children: [
          Image.asset("repo/images/general.png", fit: BoxFit.contain),
          Image.asset("repo/images/general2.png", fit: BoxFit.contain),
          Image.asset("repo/images/general3.png", fit: BoxFit.contain),
          Image.asset("repo/images/positionDataPush.png", fit: BoxFit.contain),
          Image.asset("repo/images/positionDataPush2.png", fit: BoxFit.contain),
          Image.asset("repo/images/positionDataPush3.png", fit: BoxFit.contain),
        ],
      ),
    );
  }
}
