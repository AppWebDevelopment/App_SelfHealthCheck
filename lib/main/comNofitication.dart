import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:selfchecker/data/notiComData.dart';

class ComNotification extends StatefulWidget {
  DatabaseReference _dbRefComname;

  ComNotification(this._dbRefComname);

  @override
  _ComNotificationState createState() => _ComNotificationState();
}

class _ComNotificationState extends State<ComNotification> {
  TextEditingController _notificationTitleController;
  TextEditingController _notificationContentController;
  TextEditingController _notificationTitleController2;
  TextEditingController _notificationContentController2;

  @override
  void initState() {
    super.initState();
    _notificationTitleController = TextEditingController();
    _notificationContentController = TextEditingController();
    _notificationTitleController2 = TextEditingController();
    _notificationContentController2 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _notificationTitleController.dispose();
    _notificationContentController.dispose();
    _notificationTitleController2.dispose();
    _notificationContentController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        title: Text('공지사항 Update 페이지',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: Colors.blueGrey[100],
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _notificationTitleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '공지 제목',
                      //border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _notificationContentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: '공지 내용',
                     // border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 250,
                  child: CupertinoButton(
                    onPressed: () {
                      widget._dbRefComname.child('notification')
                          .update(NotiComData(
                          title: _notificationTitleController.value.text,
                          content: _notificationContentController.value.text,
                          createTime: DateTime.now().toIso8601String(),
                          isPut: true)
                          .toJson())
                          .then((_) {
                        makeDialog('공지 갱신 완료');

                      });
                    },
                    child: Text(
                      ' \'체크 완료 후\'\n 공지 갱신하기',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blueAccent,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: 250,
                  child: CupertinoButton(
                    onPressed: () {
                      widget._dbRefComname.child('notification')
                          .update(NotiComData(
                          title: '',
                          content: '',
                          createTime: '',
                          isPut: false
                          )
                          .toJson())
                          .then((_) {
                        makeDialog('공지를 지웠습니다');

                      });
                    },
                    child: Text(
                      ' \'체크 완료 후\'\n  공지 지우기',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black54,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
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
