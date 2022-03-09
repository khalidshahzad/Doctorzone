import 'dart:convert';
import '../model/appointment_model.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

String url = '${Ip.serverip}/appointment.php';

class AppointmentServices {
  Future<List<AppointModel>> fetchclinic(uID) async {
    final response = await http.post(url, body: {'uID': uID});
    if (response.statusCode == 200) {
      List<AppointModel> _data = datafromjason(response.body);
      return _data;
    } else {
      return [];
    }
  }

  List<AppointModel> datafromjason(String jsonString) {
    final _data = jsonDecode(jsonString);
    return List<AppointModel>.from(
      _data.map(
        (item) => AppointModel.fromJson(item),
      ),
    );
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
            json.decode(response.body)['clinicData']);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
