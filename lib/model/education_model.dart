class EducationModel {
  String id, degree;
  EducationModel({this.id, this.degree});
  factory EducationModel.fromjson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as String,
      degree: json['degree'] as String,
    );
  }
}
