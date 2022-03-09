import 'dart:convert';

import '../model/doctor_personal_data_model.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

class DoctorPersonalDataServices {
  final String url =
      '${Ip.serverip}/RegisterDoctorsaccordService.php'; //url will be udated latrer
  final String url2 = '${Ip.serverip}/getCompleteDoctorProfileData.php';

  Future<Map<String, dynamic>> getAllDoctorsRecord(_sid) async {
    try {
      final response = await http.post(url, body: {'sid': _sid});
      // print('{Sid: $_sid}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
        // print(response.body);
        // List<DoctorPersonalData> data = datafromjson(
        //   response.body,
        // );
        // if (response.body.isNotEmpty) {
        //   return data.toList();
        // } else {
        //   // print("Error");
        // }
      }
    } catch (e) {
      // print(e);
    }
    return{};
  }

  List<DoctorPersonalData> datafromjson(String doctors) {
    final data = json.decode(doctors);
    return List<DoctorPersonalData>.from(
        data.map((doctor) => DoctorPersonalData.fromjason(doctor)));
  }

  Future<List<DoctorPersonalData>> getDoctorRecord(String uID) async {
    final response = await http.post(
      url2,
      body: {'uID': uID},
    );
    // print('Servoces : $uID');
    if (response.statusCode == 200) {
      // print(response.body);
      List<DoctorPersonalData> data = datafromjson2(
        response.body,
      );
      if (response.body.isNotEmpty) {
        return data.toList();
      } else {
        // print("Error");
      }
    }
    return [];
  }

  List<DoctorPersonalData> datafromjson2(String doctors) {
    final data = json.decode(doctors);
    return List<DoctorPersonalData>.from(
        data.map((doctor) => DoctorPersonalData.fromjason(doctor)));
  }
}
