import 'package:firebase_database/firebase_database.dart';

class User {
  String key='';
  String id='';
  String pw='';
  String createTime='';
  String username='';
  String userplace='';
  String userCompanyName='';
  String reservationFirst ='';
  String reservationSecond ='';


  User(this.id, this.pw, this.createTime, this.username, this.userplace, this.userCompanyName);

  User.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      id = snapshot.value['id'],
      pw = snapshot.value['pw'],
      createTime = snapshot.value['createTime'],
      username = snapshot.value['username'],
      userplace = snapshot.value['userplace'],
      userCompanyName = snapshot.value['usercompanyname'],
      reservationFirst = snapshot.value['reservationFirst'],
        reservationSecond = snapshot.value['reservationSecond'];

  User.fromSnapshotReservation(DataSnapshot snapshot)
      : reservationFirst = snapshot.value['reservationFirst'],
        reservationSecond = snapshot.value['reservationSecond'];

  toJson(){
    return{
      'id': id,
      'pw': pw,
      'createTime': createTime,
      'username': username,
      'userplace': userplace,
      'usercompanyname': userCompanyName,


    };
  }

  toJsonReservation1(){
    return{
      'reservationFirst': reservationFirst,
    };
  }

  toJsonReservation2(){
    return{
      'reservationSecond': reservationSecond,
    };
  }
}



