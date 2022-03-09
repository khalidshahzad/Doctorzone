import 'dart:convert';
import '../model/login_model.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

class SigninServices {
  String signinurl = "${Ip.serverip}/signin.php";

  Future<List<SignInModel>> getUsers() async {
    try {
      final response = await http.get(signinurl);
      if (response.statusCode == 200) {
        print('hello');
        List<SignInModel> users = usersfromjson(response.body);
        return users;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

List<SignInModel> usersfromjson(String jsonString) {
  final users = json.decode(jsonString);
  return List<SignInModel>.from(
      users.map((item) => SignInModel.fromjason(item)));
}
