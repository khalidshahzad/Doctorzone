import 'dart:convert';
import '/model/cities_model.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

class Cities {
  // ignore: non_constant_identifier_names
  String url = '${Ip.serverip}/getcities.php';

  List<CityModel> citiesFromJson(String response) {
    final data = json.decode(response);
    return List<CityModel>.from(
        data.map((service) => CityModel.fromjson(service)));
  }

  Future<List<CityModel>> getCites() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<CityModel> cities = citiesFromJson(response.body);
        return cities;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
