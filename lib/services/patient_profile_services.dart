import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/patient_model.dart';
import '../ip.dart' as Ip;

class PatientProfileServices {
  // ignore: non_constant_identifier_names
  String insert_users_url = "${Ip.serverip}/InsertProfileData.php";
  //
  String updatePatientUrl = "${Ip.serverip}/UpdateUserProfile.php";
  //
  String viewURL = "${Ip.serverip}/FetchProfile.php";
  //
  Future addPatientData(PatientModel patientModel) async {
    try {
      final response =
          await http.post(insert_users_url, body: patientModel.tojsonAdd());
      if (response.body.isNotEmpty) print(json.decode(response.body));

      if (response.statusCode == 200) {
        String message = jsonDecode(response.body.toString());
        print(" Error Occured in json : $message");

        return (message);
      } else {
        return "Error";
      }
    } catch (e) {
      print(e);
    }
  }

  List<PatientModel> patientFromjson(String response) {
    final data = json.decode(response);

    return List<PatientModel>.from(data.map((d) => PatientModel.fromJson(d)));
  }

  Future<List<PatientModel>> getdata(String id) async {
    try {
      final response = await http.post(viewURL, body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        List<PatientModel> record = patientFromjson(response.body);
        if (response.body.isNotEmpty) {
          print('patient record:$record');
          return record;
        } else {
          return null;
        }
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future upDatePatientData(PatientModel patientModel) async {
    try {
      print('\n${patientModel.tojsonUpdate()}\n');
      final response =
          await http.post(updatePatientUrl, body: patientModel.tojsonUpdate());

      if (response.statusCode == 200) {
        print('Coming Response : ${response.body}');
        print(response.body);
      } else {
        print('Error!');
      }
    } catch (e) {
      print(e);
    }
  }
}
