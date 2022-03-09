class CityModel {
  String id;
  // ignore: non_constant_identifier_names
  String country_ID;
  String city;

  // ignore: non_constant_identifier_names
  CityModel({this.id, this.country_ID, this.city});
  factory CityModel.fromjson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      country_ID: json['country_ID'] as String,
      city: json['city'] as String,
    );
  }
}
