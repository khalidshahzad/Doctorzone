import 'package:flutter/foundation.dart';

class AvailableServices {
  String id;
  // ignore: non_constant_identifier_names
  String service_Name;
  // ignore: non_constant_identifier_names
  String service_name_urdu;
  String imageURL;

  AvailableServices(
      {@required this.id,
      // ignore: non_constant_identifier_names
      @required this.service_Name,
      // ignore: non_constant_identifier_names
      @required this.service_name_urdu,
      @required this.imageURL});

  factory AvailableServices.fromJson(Map<String, dynamic> json) {
    return AvailableServices(
      id: json['id'] as String,
      service_Name: json['service_Name'],
      service_name_urdu: json['service_name_urdu'],
      imageURL: json['imageURL'],
    );
  }
}
