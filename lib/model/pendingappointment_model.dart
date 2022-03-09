class PendingAppointmentModel {
  String id,
      docid,
      docname,
      clinic,
      fee,
      status,
      message,
      appointmentdate,
      appointmenttime,
      appointmentduration,
      appointmentfor,
      patientemail,
      patientname,
      patientphone,
      patientgender;
  PendingAppointmentModel({
    this.id,
    this.docid,
    this.docname,
    this.clinic,
    this.fee,
    this.status,
    this.message,
    this.appointmentdate,
    this.appointmenttime,
    this.appointmentduration,
    this.appointmentfor,
    this.patientemail,
    this.patientphone,
    this.patientname,
    this.patientgender,
  });
  factory PendingAppointmentModel.fromjson(Map<String, dynamic> json) {
    return PendingAppointmentModel(
      id: json['id'],
      docid: json['docid'],
      docname: json['docname'],
    );
  }
}
