class DoctorModel {
  String id;

  String uID;

  String name;
  String descrption,
      // ignore: non_constant_identifier_names
      pd_pic,
      // ignore: non_constant_identifier_names
      pd_experince,
      gender,
      // ignore: non_constant_identifier_names
      pd_education,
      // ignore: non_constant_identifier_names
      pd_seceducatio,
      // ignore: non_constant_identifier_names
      pd_primryspecialization,
      // ignore: non_constant_identifier_names
      pd_secondaryspecialization;

  DoctorModel({
    this.id,
    this.uID,
    this.name,
    this.gender,
    // ignore: non_constant_identifier_names
    this.pd_education,
    // ignore: non_constant_identifier_names
    this.pd_experince,
    // ignore: non_constant_identifier_names
    this.pd_pic,
    // ignore: non_constant_identifier_names
    this.pd_primryspecialization,
    // ignore: non_constant_identifier_names
    this.pd_seceducatio,
    // ignore: non_constant_identifier_names
    this.pd_secondaryspecialization,
  });
  factory DoctorModel.fromjason(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['pd_id'] as String,
      uID: json['pd_uID'] as String,
      name: json['pd_full_name'] as String,
      gender: json['pd_gender'],
      pd_education: json['pd_education'],
      pd_experince: json['pd_experience'],
      pd_pic: json['pd_pic'],
      pd_primryspecialization: json['pd_primaryspecialization'],
      pd_seceducatio: json['pd_seceducation'],
      pd_secondaryspecialization: json['pd_secondaryspecialization'],
    );
  }
}
