import 'dart:io';

import 'package:doctorzone/screens/login_screen.dart';
import 'package:flutter/material.dart';

class PermissionScreen extends StatefulWidget {
  static const routeName = 'permissions';
  const PermissionScreen({Key key}) : super(key: key);

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
              'Our App will use Camera ,Gallery Perssion \nAllow these Permisions to countinue'),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SignInScreen.routeName);
              },
              child: Text('Allow ')),
          TextButton(
            onPressed: () {
              exit(0);

              //test SystemNavigator.pop();
            },
            child: Text('Deny'),
          ),
        ],
      ),
    );
  }
}
