class PatientModel {
  String pic; //imageName
  String picBase64; //Encoded ImageString
  String uID;
  String id;
  // ignore: non_constant_identifier_names
  String full_name;
  String gender;
  String email;
  // ignore: non_constant_identifier_names
  String cell_no;
  String whatsapp;
  // ignore: non_constant_identifier_names
  String CNIC;
  //Image url;
  String country;
  String city;
  // ignore: non_constant_identifier_names
  String date_of_Birth;
  String address;

  PatientModel({
    this.id,
    // ignore: non_constant_identifier_names
    this.full_name,
    this.gender,
    // ignore: non_constant_identifier_names
    this.cell_no,
    this.whatsapp,
    this.pic,
    // ignore: non_constant_identifier_names
    this.CNIC,
    this.country,
    this.city,
    // ignore: non_constant_identifier_names
    this.date_of_Birth,
    this.address,
    this.email,
    this.uID,
    this.picBase64,
  });

  Map<String, dynamic> tojsonAdd() {
    return {
      'pd_id': id,
      'pd_uID': uID,
      'pd_full_name': full_name,
      'pd_gender': gender,
      'pd.email': email,
      'pd_cell_no': cell_no,
      'pd_whatsapp': whatsapp,
      'pd_CNIC': CNIC,
      'pd_country': country,
      'pd_city': city,
      'pd_date_of_Birth': date_of_Birth,
      'pd_address': address,
      'pd_pic': pic,
      'imageBase64': picBase64,
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['pd_id'] as String,
      uID: json['pd_uID'] as String,
      email: json['pd_email'] as String,
      full_name: json['pd_full_name'] as String,
      date_of_Birth: json['pd_date_of_Birth'] as String,
      cell_no: json['pd_cell_no'] as String,
      CNIC: json['pd_CNIC'] as String,
      city: json['pd_city'] as String,
      pic: json['pd_pic'] as String,
      whatsapp: json['pd_whatsapp'] as String,
      address: json['pd_address'] as String,
      gender: json['pd_gender'] as String,
    );
  }

  Map<String, dynamic> tojsonUpdate() {
    return {
      'pd_id': id,
      'pd_uID': uID,
      'pd_full_name': full_name,
      'pd_gender': gender,
      'pd_email': email,
      'pd_cell_no': cell_no,
      'pd_whatsapp': whatsapp,
      'pd_CNIC': CNIC,
      'pd_country': country,
      'pd_city': city,
      'pd_date_of_Birth': date_of_Birth,
      'pd_address': address,
      'pd_pic': pic,
      'imageBase64': picBase64,
    };
  }
}
