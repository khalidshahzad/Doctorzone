import 'dart:convert';
import '../model/clinic_model.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

class ClinicServices {
  final String clinicurl = '${Ip.serverip}/clinic.php';
  Future<List<ClinicModel>> getClinicData(String uID) async {
    try {
      final response = await http.post(clinicurl, body: {'uID': uID});

      if (response.statusCode == 200) {
        List<ClinicModel> clinicdata = datafromjson2(response.body);
        return clinicdata;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  List<ClinicModel> datafromjson2(String jsonStirng) {
    final clinicdata = jsonDecode(jsonStirng);
    return List<ClinicModel>.from(
        clinicdata.map((item) => ClinicModel.fromjson(item)));
  }
}
