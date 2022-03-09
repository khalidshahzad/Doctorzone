class MessageBubbleModel {
  String id;
  String patientID;
  String doctorID;
  String message;
  String status;
  String messageTime;
  String patientName;
  String patientImage;
  String doctorName;
  String doctorImage;
  String sendByID;

  MessageBubbleModel({
    this.id,
    this.patientID,
    this.doctorID,
    this.message,
    this.status,
    this.messageTime,
    this.patientName,
    this.patientImage,
    this.doctorName,
    this.doctorImage,
    this.sendByID,
  });
  factory MessageBubbleModel.fromjason(Map<String, dynamic> json) {
    return MessageBubbleModel(
      id: json['id'],
      patientID: json['patientID'],
      doctorID: json['doctorID'],
      message: json['message'],
      status: json['status'],
      messageTime: json['messageTime'],
      patientName: json['patientName'],
      patientImage: json['patientImage'],
      doctorName: json['doctorName'],
      doctorImage: json['doctorImage'],
      sendByID: json['sendByUser'],
    );
  }
}
