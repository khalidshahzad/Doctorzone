import '../services/appointment_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/ip.dart' as Ip;

class ReplyScreen extends StatefulWidget {
  static const routeName = 'replyscreen';
  const ReplyScreen({Key key}) : super(key: key);

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final String url2 = '${Ip.serverip2}/message_store.php';

  SharedPreferences _logindata;
  var _id;
  void sendreply() async {
    var response = await http.post(url, body: {
      'puid': _id,
      'docid': 'docid',
      'message': 'mesage',
      'time': 'time'
    });
    if (response.statusCode == 200) {
      return;
    } else
      print('error occured');
  }

  @override
  void didChangeDependencies() async {
    _id = _logindata.getString('id');
    print('id:$_id');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
        title: Text('Your Message'),
      ),
      body: TextFormField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'write message',
          suffix: IconButton(
            onPressed: () async {
              sendreply();
            },
            icon: Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
