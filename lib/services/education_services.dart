import 'dart:convert';
import '/model/education_model.dart';
import 'package:http/http.dart' as http;

class EducationServices {
  final String getdegree = '';
  Future<List<EducationModel>> geteducation() async {
    final response = await http.get(getdegree);
    if (response.statusCode == 200) {
      List<EducationModel> digrees = datafromjson(response.body);
      return digrees;
    }
    return [];
  }

  List<EducationModel> datafromjson(String jsonStirng) {
    final digreedata = json.decode(jsonStirng);
    return List<EducationModel>.from(
        digreedata.map((item) => EducationModel.fromjson(item)));
  }
}
