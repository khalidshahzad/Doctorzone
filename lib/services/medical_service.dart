import 'dart:convert';
import '../model/medical_model.dart';
import 'package:http/http.dart' as http;
import '/ip.dart' as Ip;

class MedicalService {
  final String medicalrecordinserturl =
      '${Ip.serverip}/medicalrecordinsert.php';

  Future<String> addmedicalrecord(MedicalModal medicalModal) async {
    print('Service');
    final response = await http
        .post(medicalrecordinserturl, body: {medicalModal.toJsonAdd()});
    if (response.statusCode == 200) {
      print('ok working');
      var message = jsonDecode(response.body);
      print(message);
      return message;
    } else {
      return 'Error';
    }
  }
}
