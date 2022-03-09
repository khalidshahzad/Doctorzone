import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ip.dart' as Ip;
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  static const routeName = 'Appointment History';
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final String historyurl = '${Ip.serverip}/allappointments.php';
  bool _isloading = true;
  var _data;
  var userdata;
  var id;
  var _isappexpanaded = true;

  @override
  void didChangeDependencies() async {
    _isloading = true;
    userdata = await SharedPreferences.getInstance();
    id = userdata.getString('id');
    print('userid:$id');
    await getallpendingappointments();
    print('Coming Appointments : $_data');
    super.didChangeDependencies();
    setState(() {
      _isloading = false;
    });
  }

  Future getallpendingappointments() async {
    _isloading = true;
    final response = await http.post(historyurl, body: {
      'puid': id,
    });
    if (response.statusCode == 200) {
      print('history');
      _data = jsonDecode(response.body);
      print('history:$_data');

      return _data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('Appointment History'),
        centerTitle: true,
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _data['server_data'].length,
              itemBuilder: (contex, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(left: 5),
                      color: Colors.indigo.shade900,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your appointments',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: _isappexpanaded
                                ? Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    // _isappexpanaded
                                    //     ? Icon(Icons.remove)
                                    Icons.add_sharp,
                                    color: Colors.white,
                                  ),
                            onPressed: () {
                              setState(
                                () {
                                  _isappexpanaded = !_isappexpanaded;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isappexpanaded
                            ? Container(
                                child: DataTable(
                                  columnSpacing: 0.5,
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
                                                fontWeight: FontWeight.bold,
                                                color: _data['server_data']
                                                            [index]['status'] ==
                                                        'pending'
                                                    ? Colors.yellow.shade800
                                                    : _data['server_data']
                                                                    [index]
                                                                ['status'] ==
                                                            'confirm'
                                                        ? Colors.green
                                                        : _data['server_data']
                                                                        [index][
                                                                    'status'] ==
                                                                'complete'
                                                            ? Colors.blue
                                                            : Colors
                                                                .red.shade300),
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            'Appoint. Token  ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '${_data['server_data'][index]['id']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigoAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            'Appoint\n Date ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                              '${DateFormat.yMMMMd().format(
                                                DateTime.parse(
                                                  _data['server_data'][index]
                                                      ['appointmentdate'],
                                                ),
                                              )}'
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            'Appoint.\n Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '${_data['server_data'][index]['appointmenttime']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            'Your phone',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            'Hospital/Clinic',
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
                                              maxLines: 2,
                                              overflow: TextOverflow.clip),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            'Hospital/Clinic Address',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                                '${_data['server_data'][index]['address']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.clip),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 20,
                              )),
                  ],
                );
              },
            ),
    );
  }
}
