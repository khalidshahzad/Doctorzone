import 'package:flutter/foundation.dart';

class GetAppointmentModel {
  String docid,
      doctorname,
      appointmentdate,
      clinic,
      fee,
      clinicid,
      gender,
      appointmenttime,
      appointmentduration,
      appointmentfor,
      patientname,
      status,
      cancelreason,
      patientphone,
      patientemail,
      puid,
      patientgender;
  GetAppointmentModel({
    //clinicid missing
    @required this.clinicid,
    @required this.clinic,
    //docid missing
    @required this.docid,
    this.doctorname,
    this.appointmentdate,
    this.appointmentduration,
    this.appointmenttime,
    @required this.appointmentfor,
    @required this.fee,
    @required this.patientgender,
    @required this.patientname,
    @required this.patientphone,
    this.patientemail,
    //status missing
    @required this.status,
    this.cancelreason,
    @required this.puid,
  });

  factory GetAppointmentModel.fromjason(Map<String, dynamic> json) {
    return GetAppointmentModel(
      docid: json['docid'].toString(),
      doctorname: json['doctorname'],
      fee: json['fee'],
      clinic: json['clinic'],
      clinicid: json['clinicid'].toString(),
      appointmentdate: json['appointmentdate'],
      appointmentduration: json['appointmentduration'],
      appointmenttime: json['appointmenttime'],
      appointmentfor: json['appointmentfor'],
      patientgender: json['patientgender'],
      patientname: json['patientname'],
      patientphone: json['patientphone'],
      patientemail: json['patientemail'],
      status: json['status'].toString(),
      cancelreason: json['cancelreason'].toString(),
      puid: json['puid'],
    );
  }

  Map<String, dynamic> toJsonAdd1() {
    return {
      'docid': docid,
      'docname': doctorname,
      'appointmentdate': appointmentdate,
      'clinic': clinic,
      'fee': fee,
      'clinicid': clinicid,
      'appointmentduration': appointmentduration,
      'appointmenttime': appointmenttime,
      'appointmentfor': appointmentfor,
      'patientname': patientname,
      'status': status,
      'patientphone': patientphone,
      'patientgender': patientgender,
      'puid': puid
    };
  }
}
