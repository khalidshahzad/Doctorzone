import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sign_up_model.dart';
import '../ip.dart' as Ip;

class SignUpServices {
  // ignore: non_constant_identifier_names
  String ADD_URL = '${Ip.serverip}/signup.php';

  Future<String> addUser(SignUpModel signUpModel) async {
    try {
      final response = await http.post(ADD_URL, body: signUpModel.toJsonAdd());
      if (response.statusCode == 200) {
        String message = json.decode(response.body);
        print(message);
        return message;
      } else {
        return 'ERROR!';
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
