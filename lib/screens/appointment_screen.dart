import 'package:date_picker_timeline/date_picker_timeline.dart';
import '/exception.dart';
import 'getappointment_screen.dart';
import '../services/appointment_services.dart';
import 'package:intl/intl.dart';

import '../ip.dart' as Ip;

import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  static const routeName = 'Appointment_Screen';
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  var _clinicname;
  var _clinicid;
  var _data;
  var _fee;
  // ignore: unused_field
  List _clinics = [];
  List _doctors = [];
  var uID;
  bool _isloading = true;
  String _selectedDate;
  DateTime _selectedValue = DateTime.now();

  DatePickerController _controller = DatePickerController();
  // ignore: unused_field
  var _schdule;
  String _infoText = '';
  var _title = '';

  @override
  void didChangeDependencies() async {
    try {
      _data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      print('Data on Appoitment Screen : ${_data.toString()}');
      setState(() {
        _clinicname = _data['clinicData']['clinic'];
        uID = _data['clinicData']['docid'];
        // _title = _data['dtitle'];
        // print(_title);

        print('uid:$uID');
        _clinicid = _data['clinicData']['clinicids'];
        print('Clinicididchangedaapontment: $_clinicid');

        // _schdule = _data['schedule'];
        // print(_clinicid);
        _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final dayNumber = DateTime.now().weekday;

        if (dayNumber == 1) {
          print('Monday');
          if (_data['clinicData']['mondaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }
        if (dayNumber == 2) {
          print('Tuesday');
          if (_data['clinicData']['tuesdaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }

        if (dayNumber == 3) {
          print('Wednesday');
          if (_data['clinicData']['wednesdaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }

        if (dayNumber == 4) {
          print('Thursday');
          if (_data['clinicData']['thursdaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }
        if (dayNumber == 5) {
          print('Friday');
          if (_data['clinicData']['fridaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }
        if (dayNumber == 6) {
          print('Saturday');
          if (_data['clinicData']['saturdaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }
        if (dayNumber == 7) {
          print('Sunday');
          if (_data['clinicData']['sundaystatus'] == 'off') {
            setState(() {
              _infoText = 'Doctor is not available for today';
            });
          } else {
            setState(() {
              _infoText = '';
            });
          }
        }
        print(' date.now:{$_selectedValue}');
      });
      await getClinic();

      super.didChangeDependencies();
      setState(() {
        _isloading = false;
      });
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  Future getClinic() async {
    print('fukjsnksn');
    try {
      final _clinics = await AppointmentServices().fetch(uID);
      setState(() {
        _doctors = _clinics;
        //  _fee = _doctors[0]['appoitmentfee'];
        print(_clinics);
        print('Doctor clinic:{$_doctors}');
        print('fee:{$_fee}');
        _isloading = false;
      });
    } catch (e) {
      print(e);
      // ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text(_clinicname.toString()),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Card(
                  elevation: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10),
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(
                                  top: 10, left: 5, right: 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                    image: (_doctors[0]['pd_pic'] != '' ||
                                            _doctors[0]['pd_pic'] != null)
                                        ? NetworkImage(
                                            '${Ip.serverip3}/doctorimg_upload/${_doctors[0]['pd_pic']}',
                                          )
                                        : AssetImage(
                                            'asset/user.png',
                                          ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 0.0, top: 10),
                                child: Text(
                                  _doctors[0]['pd_full_name'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 0.0, top: 5),
                                child: Text(
                                  'Fee Rs.' +
                                      _doctors[0]['appoitmentfee'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Appointment Duration',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 8),
                                child: Text(
                                  '${_doctors[0]['appoitmentduration']} minutes',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: DatePicker(
                    DateTime.now(),
                    width: 60,
                    height: 80,
                    controller: _controller,
                    daysCount: 8,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.blue.shade900,
                    selectedTextColor: Colors.white,
                    inactiveDates: [
                      DateTime.now().add(Duration(days: 7)),
                    ],
                    onDateChange: (date) {
                      // New date selected
                      print(date);
                      setState(() {
                        _selectedDate =
                            DateFormat('yyyy-MM-dd').format(date) == null
                                ? _selectedValue
                                : DateFormat('yyyy-MM-dd').format(date);
                        if (date.weekday == 1) {
                          print('Monday');
                          if (_data['clinicData']['mondaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }
                        if (date.weekday == 2) {
                          print('Tuesday');
                          if (_data['clinicData']['tuesdaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }

                        if (date.weekday == 3) {
                          print('Wednesday');
                          if (_data['clinicData']['wednesdaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }

                        if (date.weekday == 4) {
                          print('Thursday');
                          if (_data['clinicData']['thursdaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }
                        if (date.weekday == 5) {
                          print('Friday');
                          if (_data['clinicData']['fridaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }
                        if (date.weekday == 6) {
                          print('Saturday');
                          if (_data['clinicData']['saturdaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }
                        if (date.weekday == 7) {
                          print('Sunday');
                          if (_data['clinicData']['sundaystatus'] == 'off') {
                            setState(() {
                              _infoText = 'Doctor is not available for today';
                            });
                          } else {
                            setState(() {
                              _infoText = '';
                            });
                          }
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Your appointment will be schedulede in betwen\n',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Text(
                  _infoText == ''
                      ? '${DateFormat.jm().format(DateFormat('hh:mm:ss').parse(_doctors[0]['mondaystarttiming']))} to ${DateFormat.jm().format(DateFormat('hh:mm:ss').parse(_doctors[0]['mondayofftiming']))}'
                      //'${_doctors[0]['mondaystarttiming'] +
                      //     '    to   ' +
                      //     _doctors[0]['mondayofftiming']}'
                      : _infoText,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'You have maximum 30 minutes against your\n         appointment',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: _infoText == 'Doctor is not available for today'
                      ? ElevatedButton(
                          child: Text('Poceed to appointment'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 25),
                              primary: Colors.grey),
                          onPressed: () {})
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 25),
                            primary: Colors.indigo.shade600,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                GetAppointmentScreen.routeName,
                                arguments: {
                                  'uID': uID,
                                  'clinic': _clinicname,
                                  'date': _selectedDate,
                                  'cliniid': _clinicid,
                                  'dtitle': _title,
                                });
                            print({uID});
                            print(_clinicname);
                            print('Selecteddate:$_selectedDate');
                            print('Clinic id:$_clinicid');
                          },
                          child: Text(
                            'Proceed to Appointment',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
