class SignInModel {
  String password;
  // ignore: non_constant_identifier_names
  String id;
  // ignore: non_constant_identifier_names
  String user_name;
  // String hash;
  // ignore: non_constant_identifier_names
  String user_type;
  // ignore: non_constant_identifier_names
  SignInModel(
      // ignore: non_constant_identifier_names
      {
    this.id,
    // ignore: non_constant_identifier_names
    this.user_name,
    // this.hash,
    // ignore: non_constant_identifier_names
    this.user_type,
    this.password,
  });
  factory SignInModel.fromjason(Map<String, dynamic> json) {
    return SignInModel(
        id: json['uID'] as String,
        user_name: json['user_name'] as String,
        password: json['password'] as String,
        user_type: json['user_type'] as String);
  }
}
