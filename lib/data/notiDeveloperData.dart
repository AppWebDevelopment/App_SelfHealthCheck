import 'package:firebase_database/firebase_database.dart';

class NotiDeveloperData {
  String key;
  String info;
  String notify;
  String createTime;

  NotiDeveloperData(this.info, this.notify, this.createTime);

  NotiDeveloperData.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        info = snapshot.value['info'],
        notify = snapshot.value['notify'],
        createTime = snapshot.value['createTime'];

  toJson(){
    return{
      'info': info,
      'notify': notify,
      'createTime': createTime,
    };
  }
}

