import 'dart:convert';
import '../model/message_buuble.dart';
import 'package:http/http.dart' as http;
import '/ip.dart' as IP;

class MessageBubbleService {
  final String url = '${IP.serverip2}/get_messages.php';
  Future<List<MessageBubbleModel>> getmessage(
      String patientId, String doctorID) async {
    print('DoctorID : $doctorID : PatientID : $patientId');
    final response = await http.post(
      url,
      body: {
        'patientID': patientId,
        'doctorID': doctorID,
      },
    );
    print('messages : ${response.body}');
    if (response.statusCode == 200) {
      final messages = json.decode(response.body);
      return List<MessageBubbleModel>.from(
        messages.map(
          (msg) => MessageBubbleModel.fromjason(msg),
        ),
      );
    } else
      return [];
  }
}
