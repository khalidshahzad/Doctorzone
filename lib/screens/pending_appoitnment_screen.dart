import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import '../screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ip.dart' as IP;

class PendingAppointmentScreen extends StatefulWidget {
  static const routeName = 'pendingappoint_screen';
  const PendingAppointmentScreen({Key key}) : super(key: key);

  @override
  _PendingAppointmentScreenState createState() =>
      _PendingAppointmentScreenState();
}

class _PendingAppointmentScreenState extends State<PendingAppointmentScreen> {
  var _data;
  bool _isloading = true;
  SharedPreferences userdata;

  var id;

  final String appointmenturl = '${IP.serverip}/getappointmentsofdoctor.php';

  Future<List<String>> _getPatientPlayerID(int index) async {
    final getPPIDURL = '${IP.serverip2}/getPatientPlayerID.php';
    final response = await http.post(
      getPPIDURL,
      body: {
        'puid': _data['server_data'][index]['docID'],
      },
    );
    print(
        'uID : ${_data['server_data'][index]['docID']} : PlayerID : ${response.body}');
    List<String> playerIDs = [];
    playerIDs.add(json.decode(response.body).toString());
    return playerIDs;
  }

  //03200468789

  Future<void> _sendNotification(
      List<String> patientPlayerID, String content) async {
    final response = await http.post(
      'https://onesignal.com/api/v1/notifications',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic>{
        "app_id": '97bd0974-bb83-4513-b40c-dfe622e3c00f', // Umer AppID
        // "app_id": 'ac0d8f95-7843-4615-94d4-69273b872c39', //Khalid AppID
        "include_player_ids": patientPlayerID,
        "android_accent_color": "FF9976D2",
        "small_icon": "ic_stat_onesignal_default",
        "large_icon":
            "https://play-lh.googleusercontent.com/kiXQHhYoeuVlMIlM3glNITwwoGtOa6bVnGO6TvR4v1vGqjaAA4IrpQUWJfKrT8egpQ",
        "headings": {"en": "DoctorZone.pk"},
        "contents": {"en": content},
      }),
    );
    print('Send notification Response : ${response.body}');
  }

  void didChangeDependencies() async {
    _isloading = true;
    userdata = await SharedPreferences.getInstance();
    id = userdata.getString('id');
    print('userid:$id');
    // _timer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
    await getpendingappointment();
    // });
    // await getpendingappointment();
    // await getcancelledappointment();
    // await getcomletedappointment();
    // await getconfirmedappointment();

    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  //[12:18, 25/08/2021] Umer Bzu: // "app_id": '97bd0974-bb83-4513-b40c-dfe622e3c00f',    // Umer AppID
//[12:27, 25/08/2021] Umer Bzu://

  Future getpendingappointment() async {
    _isloading = true;
    final response = await http
        .post(appointmenturl, body: {'puid': id, 'status': 'pending'});
    if (response.statusCode == 200) {
      _data = jsonDecode(response.body);
      print('pendingappointment:$_data');

      return _data;
    }

    setState(() {
      _isloading = false;
    });
  }

  Future getcomletedappointment() async {
    _isloading = true;
    final response = await http
        .post(appointmenturl, body: {'puid': id, 'status': 'complete'});
    if (response.statusCode == 200) {
      _data = jsonDecode(response.body);
      print('complete:$_data');
      setState(() {
        _isloading = false;
      });
      return _data;
    }

    setState(() {
      _isloading = false;
    });
  }

  Future getcancelledappointment() async {
    _isloading = true;
    final response =
        await http.post(appointmenturl, body: {'puid': id, 'status': 'cancel'});
    if (response.statusCode == 200) {
      print('cancellappointment');
      _data = jsonDecode(response.body);
      print('complete:$_data');
      setState(() {
        _isloading = false;
      });
      return _data;
    }

    setState(() {
      _isloading = false;
    });
  }

  Future getallpendingappointments() async {
    _isloading = true;
    final response = await http
        .post(appointmenturl, body: {'puid': id, 'status': 'pending'});
    if (response.statusCode == 200) {
      print('cancellappointment');
      _data = jsonDecode(response.body);
      print('complete:$_data');
      setState(() {
        _isloading = false;
      });
      return _data;
    }

    setState(() {
      _isloading = false;
    });
  }

  Future getconfirmedappointment() async {
    _isloading = true;
    final response = await http
        .post(appointmenturl, body: {'puid': id, 'status': 'confirm'});
    if (response.statusCode == 200) {
      print('cancellappointment');
      _data = jsonDecode(response.body);
      print('complete:$_data');
      setState(() {
        _isloading = false;
      });
      return _data;
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Card(
              margin: EdgeInsets.only(
                top: 10,
                left: 8.0,
                right: 8.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                          ),
                          onPressed: () async {
                            setState(() {
                              _data = '';
                            });
                            await getcomletedappointment();
                            // Navigator.of(context)
                            //     .pushNamed(PendingAppointmentScreen.routeName);
                          },
                          child: Text(
                            'Completed',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                          ),
                          onPressed: () async {
                            setState(() {
                              _data = '';
                            });
                            await getallpendingappointments();
                            // Navigator.of(context)
                            //     .pushNamed(PendingAppointmentScreen.routeName);
                          },
                          child: Text(
                            'All pending',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 30,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _data = '';
                            });
                            await getconfirmedappointment();
                          },
                          child: Text('Confirmed',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo)),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 30,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _data = '';
                            });
                            await getcancelledappointment();
                          },
                          child: Text('Cancelled',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 220,
                    child: _data['server_data'].length == 0
                        ? Center(
                            child: Text('No Record Found'),
                          )
                        : ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _data['server_data'].length,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                // title: Text('something else'),
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, left: 5),
                                          child: Text(
                                            'Doctor Name:   ' +
                                                _data['server_data'][index]
                                                    ['doctorName'],
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 20),
                                          width: 1,
                                          color: Colors.black,
                                          child: VerticalDivider(
                                            color: Colors.black,
                                            thickness: 2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                          ),
                                          child: Text(
                                            'Fee Rs. ${_data['server_data'][index]['appoitmentfee']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      //margin: EdgeInsets.all(1),
                                      child: DataTable(
                                        horizontalMargin: 0,
                                        dividerThickness: 0,
                                        columns: <DataColumn>[
                                          DataColumn(
                                            label: Text(''),
                                          ),
                                          DataColumn(
                                            label: Text(''),
                                          ),
                                        ],
                                        rows: <DataRow>[
                                          DataRow(
                                            cells: [
                                              DataCell(
                                                Icon(
                                                  Icons.flag,
                                                  size: 35,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  _data['server_data'][index]
                                                      ['status'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _data['server_data']
                                                                      [index]
                                                                  ['status'] ==
                                                              'pending'
                                                          ? Colors
                                                              .yellow.shade800
                                                          : _data['server_data']
                                                                          [index]
                                                                      [
                                                                      'status'] ==
                                                                  'confirm'
                                                              ? Colors.green
                                                              : _data['server_data']
                                                                              [index]
                                                                          [
                                                                          'status'] ==
                                                                      'complete'
                                                                  ? Colors.blue
                                                                  : Colors.red
                                                                      .shade300),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(
                                                  'Appoint.Token:  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${_data['server_data'][index]['id']}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.indigoAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  'Appoint.Date :',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${DateFormat.yMMMMd().format(
                                                    DateTime.parse(
                                                      _data['server_data']
                                                              [index]
                                                          ['appointmentdate'],
                                                    ),
                                                  )}'
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(
                                                  'Appoint.Time:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${_data['server_data'][index]['appointmenttime']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(
                                                  'Your phone:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${_data['server_data'][index]['pd_cell_no']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(
                                                  'Hospital/Clinic:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${_data['server_data'][index]['name']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(
                                                  'Hospital/Clinic Address:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${_data['server_data'][index]['address']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    _data['server_data'][index]['status'] ==
                                                'cancel' ||
                                            _data['server_data'][index]
                                                    ['status'] ==
                                                'complete' ||
                                            _data['server_data'][index]
                                                    ['status'] ==
                                                'confirm'
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 35,
                                                      vertical: 18),
                                                  primary:
                                                      Colors.yellow.shade800),
                                              onPressed: () async {
                                                List<String> playerID =
                                                    await _getPatientPlayerID(
                                                        index);
                                                await _sendNotification(
                                                    playerID,
                                                    'Appointment Cancelled');
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    content: Row(
                                                      children: [
                                                        CircularProgressIndicator(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(
                                                              'Please Wait'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );

                                                await http.post(
                                                  '${IP.serverip}/updatestatusofappointment.php',
                                                  body: {
                                                    'message':
                                                        'cancel by patient',
                                                    'puid': id,
                                                    'id': _data['server_data']
                                                        [index]['id'],
                                                    'status': 'cancel',
                                                    'cancelID': id,
                                                    'cancelTime': DateTime.now()
                                                        .toString(),
                                                  },
                                                );
                                                print('Here 2');

                                                print(DateTime.now());
                                                print({id});

                                                Navigator.of(context).pop();
                                                // Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        ServicesScreen
                                                            .routeName,
                                                        arguments: {
                                                      'index': 1,
                                                    });
                                                //Navigator.of(context)
                                                // .popUntil((route) => false);
                                              },
                                              child: Text(
                                                'Cancel Appointment',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Divider(
                                      thickness: 2,
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ),
    );
  }
}
