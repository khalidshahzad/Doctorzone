import 'dart:convert';
import '../model/getappointment_model.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

class GetAppointmentService {
  final String postAptmnturl = '${Ip.serverip}/Insetappointment.php';
  Future<String> addAppointment(GetAppointmentModel appointmentModel) async {
    try {
      final response =
          await http.post(postAptmnturl, body: appointmentModel.toJsonAdd1());

      if (response.statusCode == 200) {
        print('your appointment called');
        var data = jsonDecode(response.body);
        print('Data:$data');
        return data;
      } else {
        return 'Error ocuured';
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
