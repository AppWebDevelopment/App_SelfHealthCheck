import 'package:firebase_database/firebase_database.dart';

class CheckList {
  String key;
  String id;
  String checkTime;
  String name;
  String companyName;
  String place;
  bool isFever;
  bool isCough;
  bool isThroatPain;
  bool isDyspnea;
  bool isActivity;
  bool isGroupAct;
  bool isContact;
  bool isTodayChecked;
  int checkedNum;


  CheckList(
    this.id,
    this.checkTime,
    this.name,
    this.place,
    this.companyName,
    this.isFever,
    this.isCough,
    this.isThroatPain,
    this.isDyspnea,
    this.isActivity,
    this.isGroupAct,
    this.isContact,
    this.isTodayChecked,
  );

  CheckList.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id = snapshot.value['id'],
        checkTime = snapshot.value['checktime'],
        name = snapshot.value['username'],
        companyName = snapshot.value['companyname'],
        place = snapshot.value['place'],
        isFever = snapshot.value['fever'],
        isCough = snapshot.value['cough'],
        isThroatPain = snapshot.value['throatpain'],
        isDyspnea = snapshot.value['dyspnea'],
        isActivity = snapshot.value['activity'],
        isGroupAct = snapshot.value['groupact'],
        isContact = snapshot.value['contact'],
        isTodayChecked = snapshot.value['todaychecked'],
        checkedNum = snapshot.value['checknum'];

  CheckList.fromSnapshotDetectNochecker(DataSnapshot UserSnapshot)
      : key = UserSnapshot.value['id'],
        id = UserSnapshot.value['id'],
        checkTime = '0000-00-00-00:00',
        name = UserSnapshot.value['username'],
        place = UserSnapshot.value['userplace'],
        companyName = '',
        isFever = false,
        isCough = false,
        isThroatPain = false,
        isDyspnea = false,
        isActivity = false,
        isGroupAct = false,
        isContact = false,
        isTodayChecked = false,
        checkedNum = 0;


  toJson(){

    List<bool> checkBoolList = new List();

    checkedNum = 0;

    checkBoolList.add(isFever);
    checkBoolList.add(isCough);
    checkBoolList.add(isThroatPain);
    checkBoolList.add(isDyspnea);
    checkBoolList.add(isActivity);
    checkBoolList.add(isGroupAct);
    checkBoolList.add(isContact);

    for(int i=0; i< checkBoolList.length; i++)
      {
        if(checkBoolList[i]==true)
          {
            checkedNum++;
          }
      }

    return{
      'id': id,
      'checktime': checkTime,
      'username': name,
      'companyname': companyName,
      'place': place,
      'fever': isFever,
      'cough': isCough,
      'throatpain': isThroatPain,
      'dyspnea': isDyspnea,
      'activity': isActivity,
      'groupact': isGroupAct,
      'contact': isContact,
      'todaychecked': isTodayChecked,
      'checknum': checkedNum,
    };
  }
}
