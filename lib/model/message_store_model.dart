class MessageStoreModel {
  String patientID;
  String doctorID;
  String sendByID;
  String message;
  String status;
  String timeStamp;
  MessageStoreModel({
    this.patientID,
    this.doctorID,
    this.sendByID,
    this.message,
    this.status,
    this.timeStamp,
  });
  factory MessageStoreModel.fromjason(Map<String, dynamic> json) {
    return MessageStoreModel(
      patientID: json['patientID'],
      doctorID: json['doctorID'],
      sendByID: json['sendByID'],
      message: json['message'],
      status: json['status'],
      timeStamp: json['timeStamp'],
    );
  }
  Map<String, dynamic> toJsonAdd1() {
    return {
      'patientID': patientID,
      'doctorID': doctorID,
      'sendByID': sendByID,
      'message': message,
      'status': status,
      'timeStamp': timeStamp,
    };
  }
}
