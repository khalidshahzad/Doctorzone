class DoctorPersonalData {
  String id;
  String uID;
  // ignore: non_constant_identifier_names
  String full_name;
  String gender;
  String email;
  // ignore: non_constant_identifier_names
  String cell_no;
  // ignore: non_constant_identifier_names
  String land_line_no;
  String whatsapp;
  // ignore: non_constant_identifier_names
  String CNIC;
  // ignore: non_constant_identifier_names
  String PMDC;
  String pic;
  // ignore: non_constant_identifier_names
  String professional_Statement;
  String country;
  String city;
  String address;
  // ignore: non_constant_identifier_names
  String date_of_Birth;
  // ignore: non_constant_identifier_names
  String awarduID;
  // ignore: non_constant_identifier_names
  String user_type;
  String awardtitle;
  String awardDate;
  String experience;
  String expyears;
  String expinstitute;
  String expcity;
  String expcountry;
  String membership;
  String memberstrdt;
  String memberenddt;
  String memberinstitute;
  String membercity;
  String membcountry;
  String memberdescp;
  String membUID;
  // ignore: non_constant_identifier_names
  String edu_uID;
  // ignore: non_constant_identifier_names
  String edu_degreeID;
  // ignore: non_constant_identifier_names
  String edu_passing_year;
  // ignore: non_constant_identifier_names
  String exp_uID;
  // ignore: non_constant_identifier_names
  String exp_institute;
  // ignore: non_constant_identifier_names
  String exp_start_date;
  // ignore: non_constant_identifier_names
  String exp_end_date;
  // ignore: non_constant_identifier_names
  String exp_experience_in_years;
  // ignore: non_constant_identifier_names
  String exp_designation;
  // ignore: non_constant_identifier_names
  String exp_responsibilities;
  // ignore: non_constant_identifier_names
  String exp_city;
  // ignore: non_constant_identifier_names
  String exp_country;
  // ignore: non_constant_identifier_names
  String exp_user_type;

  DoctorPersonalData(
      {this.id,
      this.uID,
      this.whatsapp,
      // ignore: non_constant_identifier_names
      this.full_name,
      this.gender,
      // ignore: non_constant_identifier_names
      this.CNIC,
      this.email,
      // ignore: non_constant_identifier_names
      this.land_line_no,
      // ignore: non_constant_identifier_names
      this.PMDC,
      this.pic,
      // ignore: non_constant_identifier_names
      this.professional_Statement,
      this.country,
      this.city,
      // ignore: non_constant_identifier_names
      this.date_of_Birth,
      // ignore: non_constant_identifier_names
      this.edu_uID,
      // ignore: non_constant_identifier_names
      this.edu_degreeID,
      // ignore: non_constant_identifier_names
      this.edu_passing_year,
      // ignore: non_constant_identifier_names
      this.exp_uID,
      // ignore: non_constant_identifier_names
      this.cell_no,
      // ignore: non_constant_identifier_names
      this.exp_city,
      // ignore: non_constant_identifier_names
      this.exp_country,
      // ignore: non_constant_identifier_names
      this.exp_designation,
      // ignore: non_constant_identifier_names
      this.exp_institute,
      // ignore: non_constant_identifier_names
      this.exp_start_date,
      // ignore: non_constant_identifier_names
      this.user_type,
      // ignore: non_constant_identifier_names
      this.exp_end_date,
      // ignore: non_constant_identifier_names
      this.exp_experience_in_years,
      // ignore: non_constant_identifier_names
      this.exp_responsibilities,
      // ignore: non_constant_identifier_names
      this.exp_user_type,
      this.awardtitle,
      this.awardDate,
      this.membUID,
      this.membership,
      this.membcountry,
      this.membercity,
      this.memberdescp,
      this.memberenddt,
      this.memberstrdt,
      this.memberinstitute,
      this.awarduID});

  factory DoctorPersonalData.fromjason(Map<String, dynamic> json) {
    return DoctorPersonalData(
      id: json['pd_id'] as String,
      uID: json['pd_uID'] as String,
      full_name: json['pd_full_name'] as String,
      email: json['pd_email'] as String,
      whatsapp: json['pd_whatsapp'] as String,
      land_line_no: json['pd_land_line_no'] as String,
      gender: json['pd_gender'] as String,
      CNIC: json['pd_CNIC'] as String,
      PMDC: json['pd_PMDC'] as String,
      pic: json['pd_pic'] as String,
      professional_Statement: json['pd_professional_Statement'] as String,
      country: json['pd_country'] as String,
      city: json['pd_city'] as String,
      date_of_Birth: json['pd_date_of_Birth'] as String,
      user_type: json['pd_user_type'] as String,
      awarduID: json['uID'] as String,
      membUID: json['mem_uID'] as String,
      membcountry: json['mem_country'] as String,
      membercity: json['mem_city'] as String,
      memberenddt: json['mem_endingDate'] as String,
      memberinstitute: json['mem_institute'] as String,
      memberstrdt: json['mem_startingDate'] as String,
      awardtitle: json['award_Title'] as String,
      edu_degreeID: json['edu_degreeID'] as String,
      edu_passing_year: json['edu_passing_year'] as String,
      edu_uID: json['edu_uID'] as String,
      exp_city: json['exp_city'] as String,
      exp_country: json['exp_country'] as String,
      exp_designation: json['exp_designation'] as String,
      exp_end_date: json['exp_end_date'] as String,
      exp_experience_in_years: json['exp_experience_in_years'],
      exp_institute: json['exp_institute'] as String,
      exp_responsibilities: json['exp_responsibilities'] as String,
      exp_start_date: json['exp_start_date'] as String,
      exp_uID: json['exp_uID'] as String,
      exp_user_type: json['exp_user_type'] as String,
    );
  }
}
