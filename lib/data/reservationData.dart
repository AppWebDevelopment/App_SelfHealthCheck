import 'package:firebase_database/firebase_database.dart';

class ReservationData {
  String key;
  String id;
  String kind;
  String MonthDay;
  String Hour;
  String name;
  String place;
  String order;


  ReservationData(
    this.id,
    this.kind,
    this.MonthDay,
    this.Hour,
    this.name,
    this.place,
    this.order,
  );

  ReservationData.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id = snapshot.value['id'],
        kind = snapshot.value['kind'],
        MonthDay = snapshot.value['MonthDay'],
        Hour = snapshot.value['Hour'],
        name = snapshot.value['name'],
        place = snapshot.value['place'],
        order = snapshot.value['order'];

  toJson(){
    return{
      'id': id,
      'kind': kind,
      'MonthDay': MonthDay,
      'Hour': Hour,
      'name': name,
      'place': place,
      'order': order,
    };
  }
}
