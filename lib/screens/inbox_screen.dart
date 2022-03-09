// ignore_for_file: unused_import

import 'package:doctorzone/message_bubble.dart';
import 'package:doctorzone/model/message_buuble.dart';
import 'package:doctorzone/services/message_bubble_servicce.dart';
import 'package:doctorzone/screens/reply%20screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = 'inbox screen';
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
        title: Text('Messages'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return;
              // return MessageBubble(, _username, _userimage, _isMe);
              // ListTile(
              //   hoverColor: Colors.grey,
              //   title: Text('messege'),
              //   onTap: () {
              //     Navigator.of(context)
              //         .pushReplacementNamed(ReplyScreen.routeName);
              //   },
              // );
            },
          ),
        ],
      ),
    );
  }
}
