import 'package:firebase_database/firebase_database.dart';

class NotiComData {
  String key;
  String title;
  String content;
  String createTime;
  bool  isPut;

  NotiComData({this.title, this.content, this.createTime, this.isPut});


  NotiComData.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        content = snapshot.value['content'],
        createTime = snapshot.value['createTime'],
        isPut = snapshot.value['isput'];

  toJson(){
    return{
      'title': title,
      'content': content,
      'createTime': createTime,
      'isput': isPut,
    };
  }

}
