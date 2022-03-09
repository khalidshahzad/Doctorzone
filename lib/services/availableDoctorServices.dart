// import 'dart:convert';
// import '../model/doctorModel.dart';
// import 'package:http/http.dart' as http;
// import '../ip.dart' as Ip;

// String url = '${Ip.serverip}/Doctordata.php';

// class AvailAbleDoctorServicse {
//   Future<List<DoctorModel>> getDoctorsdata(String _cityID) async {
//     try {
//       final response = await http.post(url, body: {'cityID': _cityID});
//       if (response.statusCode == 200) {
//         List<DoctorModel> data = datafromjson(response.body);
//         return data;
//       }

//       return [];
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
// }

// List<DoctorModel> datafromjson(String jsonString) {
//   final data = jsonDecode(jsonString);
//   return List<DoctorModel>.from(
//       data.map((item) => DoctorModel.fromjason(item)));
// }
