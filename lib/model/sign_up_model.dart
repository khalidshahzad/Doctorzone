import 'package:password/password.dart';

class SignUpModel {
  String id;
  // ignore: non_constant_identifier_names
  String fullname;
  String password;
  String gender;
  String phonenumber;
  //String hash;
  // ignore: non_constant_identifier_names
  String user_type;

  PBKDF2 algorithm;

  SignUpModel({
    this.id,
    this.password,
    // ignore: non_constant_identifier_names
    this.fullname,
    this.phonenumber,
    this.gender,

    // this.hash,
    // ignore: non_constant_identifier_names
    this.user_type,
  }) {
    //this.algorithm = new PBKDF2();
    // this.hash = Password.hash(password, this.algorithm);
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      id: json['id'] as String,
      fullname: json['full_name'] as String,
      password: json['password'] as String,
      user_type: json['user_type'] as String,
      phonenumber: json['phonenumber'] as String,
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      'full_name': fullname,
      'password': password,
      'user_type': user_type,
      'phonenumber': phonenumber,
      'gender': gender,
    };
  }
}
