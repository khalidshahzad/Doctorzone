import 'dart:async';

import 'package:doctorzone/message_bubble.dart';
import 'package:doctorzone/model/message_buuble.dart';
import 'package:doctorzone/model/message_store_model.dart';
import 'package:doctorzone/services/message_bubble_servicce.dart';
import 'package:doctorzone/services/message_store.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ip.dart' as IP;

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isInit = true;
  bool _isLoadig = true;
  String _patientID;
  String _doctorID;
  List<MessageBubbleModel> _messages;
  SharedPreferences _loginData;
  TextEditingController _messagecontroller = TextEditingController();
  var sendByID = '';

  Future<void> initial() async {
    _loginData = await SharedPreferences.getInstance();
    _patientID = _loginData.getString('id');
  }

  Future<void> _getMessages() async {
    _messages = await MessageBubbleService().getmessage(_patientID, _doctorID);
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _doctorID = data['doctorID'];

      await initial();
      await _getMessages();
      setState(() {
        _isLoadig = false;
      });
    }
    _isInit = false;
    Timer.periodic(Duration(seconds: 5), (_) async {
      await _getMessages();
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.indigo[900],
      ),
      body: _isLoadig
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.indigo[900],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (ctx, index) => MessageBubble(
                      _messages[index].message,
                      _messages[index].sendByID == _patientID
                          ? _messages[index].patientName
                          : _messages[index].doctorName,
                      _messages[index].sendByID == _patientID
                          ? '${IP.serverip}/uploads/${_messages[index].patientImage}'
                          : '${IP.serverip3}/doctorimg_uploads/${_messages[index].doctorImage}',
                      _messages[index].sendByID == _patientID,
                    ),
                    itemCount: _messages.length,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: TextField(
                          onSubmitted: (_) {},
                          controller: _messagecontroller,
                          keyboardAppearance: Brightness.dark,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            label: Text('Write Message'),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _messagecontroller.text.length == 0
                          ? null
                          : () async {
                              MessageStoreModel messageStoreModel =
                                  MessageStoreModel(
                                patientID: _patientID,
                                doctorID: _doctorID,
                                message: _messagecontroller.text.trim(),
                                status: '0',
                                sendByID: _patientID,
                                timeStamp: DateTime.now().toString(),
                              );
                              await MessageStoreService()
                                  .storemessage(messageStoreModel);
                            },
                      icon: Icon(
                        Icons.send,
                        color: _messagecontroller.text.length == 0
                            ? Colors.grey
                            : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
