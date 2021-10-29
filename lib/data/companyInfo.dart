import 'package:firebase_database/firebase_database.dart';

class CompanyInfo {
  String key;
  String id;
  String pwEmployee;//직원이 회원가입할때 회사 비밀번호
  String pw;//관리자가 로그인할때 비밀번호
  String createTime;
  String comName;
  String comPlace;
  String comContactPhone;
  String comContactName;

  CompanyInfo(this.id, this.pwEmployee, this.comContactPhone, this.comName,this.pw, this.comContactName, this.comPlace, this.createTime);

  CompanyInfo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id = snapshot.value['id'],
        pw = snapshot.value['pw'],
        pwEmployee = snapshot.value['pwemployee'],
        createTime = snapshot.value['createTime'],
        comName = snapshot.value['comname'],
        comPlace = snapshot.value['complace'],
        comContactPhone = snapshot.value['comcontactphone'],
        comContactName = snapshot.value['comcontactname'];

  toJson(){
    return{
      'id': id,
      'pwemployee': pwEmployee,
      'pw': pw,
      'createTime': createTime,
      'comname': comName,
      'complace': comPlace,
      'comcontactphone': comContactPhone,
      'comcontactname': comContactName,
    };
  }
}
