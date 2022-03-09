import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/available_services_model.dart';
import '../ip.dart' as Ip;

class FetchingServices {
  String viewURL = '${Ip.serverip}/getservices.php';
  List<AvailableServices> servicesFromJson(String response) {
    final data = json.decode(response);
    return List<AvailableServices>.from(
      data.map(
        (service) => AvailableServices.fromJson(service),
      ),
    );
  }

  Future<List<AvailableServices>> getServices() async {
    try {
      final response = await http.get(viewURL);

      if (response.statusCode == 200) {
        List<AvailableServices> services = servicesFromJson(response.body);
        return services;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
