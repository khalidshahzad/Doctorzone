
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/selected_doctor_complete_profile_modal.dart';

import '../ip.dart' as Ip;

class DoctorPersonalDataServices {
  final String url = '${Ip.serverip}/doctorprofiledata.php'; //servrip

  Future<List<SelectedDoctorProfileModel>> getDoctorsRecord(String uID) async {
    final response = await http.post(
      url,
      body: {'uID': uID},
    );
    if (response.statusCode == 200) {
      List<SelectedDoctorProfileModel> data = datafromjson(response.body);
      if (response.body.isNotEmpty) {
        return data;
      } else {
        print("Error");
      }
    }
    return [];
  }

  List<SelectedDoctorProfileModel> datafromjson(doctors) {
    final data = json.decode(doctors);
    return List<SelectedDoctorProfileModel>.from(
        data.map((doctor) => SelectedDoctorProfileModel.fromjason(doctor)));
  }

  Future<List<Map<String, dynamic>>> fetch(String uID) async {
    try {
      http.Response response = await http.post(
        url,
        body: {'uID': uID},
      );
      print('uidof doctors:{$uID}');
      if (response.statusCode != 200) {
        return null;
      } else {
        return List<Map<String, dynamic>>.from(
            json.decode(response.body)['personalData']);
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetch2(String _uID) async {
    http.Response response = await http.post(
      url,
      body: {'uID': _uID},
    );
    print('DoctorUid:{$_uID}');
    if (response.statusCode != 200) {
      return null;
    } else {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)['personalData']);
    }
  }
}
