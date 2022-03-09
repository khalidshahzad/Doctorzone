import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/medicalrecord_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as IP;

class PreviousMedicalRecordScreen extends StatefulWidget {
  static const routeName = '/Previousmedical record';
  @override
  _PreviousMedicalRecordScreenState createState() =>
      _PreviousMedicalRecordScreenState();
}

class _PreviousMedicalRecordScreenState
    extends State<PreviousMedicalRecordScreen> {
  bool _isloading = true;
  var _data;
  SharedPreferences userdata;
  var id;
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _isloading = true;
    userdata = await SharedPreferences.getInstance();
    id = userdata.getString('id');
    await getmedicalrecord();
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  final String medicurl = '${IP.serverip2}/getPatientMedicalRecord.php';
  Future getmedicalrecord() async {
    final response = await http.post(medicurl, body: {'pID': id});
    if (response.statusCode == 200) {
      _data = jsonDecode(response.body);
      print(_data.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    15,
                  ),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 25)),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MedicalRecordScreen.routeName);
                    },
                    child: Text(
                      'upload new Record',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                _data.length == 0
                    ? Center(
                        child: Text('No Data Found'),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _data.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            title: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height - 400,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${IP.serverip}/uploads/${_data[index]['imagename']}',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                Text(''),
              ],
            ),
    );
  }
}
