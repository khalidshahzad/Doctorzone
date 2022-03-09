import 'dart:convert';

import 'package:doctorzone/model/message_store_model.dart';

import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

class MessageStoreService {
  final String msgurl = '${Ip.serverip2}/message_store.php';
  Future<String> storemessage(MessageStoreModel messageStoreModel) async {
    print('Called Json : ${messageStoreModel.toJsonAdd1()}');
    try {
      final response =
          await http.post(msgurl, body: messageStoreModel.toJsonAdd1());
      if (response.statusCode == 200) {
        final message = jsonDecode(response.body);
        if (message == 'Success!') {
          return 'Message sent successfully';
        } else {
          return 'Error!';
        }
        // return message;
      } else {
        return 'Error!';
      }
    } catch (e) {
      print(e);
      return 'Error!';
    }
  }
}
