import 'dart:convert';
import '../screens/services_screen.dart';
import 'package:intl/intl.dart';
import '../ip.dart' as IP;
import '/exception.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../services/getappointment_service.dart';
import '../model/getappointment_model.dart';
import '../ip.dart' as Ip;
import '../services/appointment_services.dart';
import 'package:http/http.dart' as http;

enum Gender { Male, Female, Other }

class GetAppointmentScreen extends StatefulWidget {
  static const routeName = 'getAppointment_screen';
  @override
  _GetAppointmentScreenState createState() => _GetAppointmentScreenState();
}

class _GetAppointmentScreenState extends State<GetAppointmentScreen> {
  // ignore: non_constant_identifier_names
  TextEditingController _PatientName = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController _PhoneNumber = TextEditingController();

  SharedPreferences _userdata;
  var _id;
  String _selectedValue;
  var _gender = Gender.Male;
  List<String> _appointmentFor = [
    'Myself',
    'Spouse',
    'Child',
    'Parent',
    'Other',
  ];
  String _hintText;
  var uID;
  var _date;
  String clinic;
  String _clinicid;
  String _message;
  bool _save = false;
  bool _isLoading = true;
  List _doctors = [];
  var _title = '';

  //

  Future<List<String>> _getPatientPlayerID(int index) async {
    print('_getPatientPlayerID Called');
    final getPPIDURL = '${IP.serverip2}/getPatientPlayerID.php';
    final response = await http.post(
      getPPIDURL,
      body: {
        'puid': uID,
      },
    );
    print('uID : $uID : PlayerID : ${response.body}');
    List<String> playerIDs = [];
    playerIDs.add(json.decode(response.body).toString());
    return playerIDs;
  }

  //03200468789

  Future<void> _sendNotification(
      List<String> patientPlayerID, String content) async {
    print('_sendNotification Called');
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

  // Future<void> _sendNotification(
  //     List<String> patientPlayerID, String content) async {
  //   final response = await http.post(
  //     'https://onesignal.com/api/v1/notifications',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode(<String, dynamic>{
  //       // "app_id": '97bd0974-bb83-4513-b40c-dfe622e3c00f',    // Umer AppID
  //       "app_id": '08159fc9-01a3-4811-a0ad-b5766c48f2df', //Khalid AppID
  //       "include_player_ids": patientPlayerID,
  //       "android_accent_color": "FF9976D2",
  //       "small_icon": "ic_stat_onesignal_default",
  //       "large_icon":
  //           "https://play-lh.googleusercontent.com/kiXQHhYoeuVlMIlM3glNITwwoGtOa6bVnGO6TvR4v1vGqjaAA4IrpQUWJfKrT8egpQ",
  //       "headings": {"en": "DoctorZone.pk"},
  //       "contents": {"en": content},
  //     }),
  //   );
  //   print('Send notification Response : ${response.body}');
  // }

  @override
  void didChangeDependencies() async {
    _userdata = await SharedPreferences.getInstance();
    _id = _userdata.getString('id');
    print('$_id');

    var _data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    setState(() {
      _hintText = _appointmentFor[0];
      uID = _data['uID'];
      clinic = _data['clinic'];
      _date = _data['date'];
      _title = _data['dtitle'];
      _clinicid = _data['cliniid'];
      // var formateddate = DateFormat.yMMMd().format(_date);
      // print('Formateddataed:$formateddate');

      print('GetAppointmentSettingDate : $_date');
      print('GetAppointmentclinicid : $_clinicid');

      print(uID);
      print(clinic);
      print('Value : $_date');
    });
    await getdoctorsData();

    super.didChangeDependencies();
  }

  Future getdoctorsData() async {
    try {
      final _doctor = await AppointmentServices().fetch(uID);
      setState(() {
        _doctors = _doctor;
        _isLoading = false;
      });
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  Future<void> addAppointmentData(GetAppointmentModel appointmentModel) async {
    setState(() {
      _save = true;
    });
    _message = await GetAppointmentService().addAppointment(appointmentModel);
    setState(() {
      _save = false;
    });
    if (_message == 'Record Already Exists') {
      Toast.show('Username already exists', context,
          duration: 5, gravity: Toast.BOTTOM);
    } else {
      Toast.show('Appointment Request Submitted', context,
          duration: 5, gravity: Toast.BOTTOM);
    }
  }

  bool validate() {
    if (_PatientName.text.trim().isEmpty || _PatientName.text.trim() == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter Patient Name',
          ),
        ),
      );
      return false;
    }
    if (_PhoneNumber.text.trim().isEmpty || _PhoneNumber.text.trim() == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter Patient Phone Number',
          ),
        ),
      );
      return false;
    } else if (_PhoneNumber.text.trim().length < 11) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter Valid Phone Number',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text(_isLoading ? "" : clinic),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                height: 90,
                                width: 90,
                                margin:
                                    const EdgeInsets.only(left: 8, bottom: 60),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                      scale: 1,
                                      image: (_doctors[0]['pd_pic'] == '' &&
                                              _doctors[0]['pd_pic'] == "")
                                          ? AssetImage(
                                              'asset/user.png',
                                            )
                                          // NetworkImage(
                                          //     '${Ip.serverip2}/uploads/${_doctors[0]["pd_pic"]}',
                                          //   )
                                          : NetworkImage(
                                              '${Ip.serverip3}/doctorimg_upload/${_doctors[0]["pd_pic"]}',
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
                                      const EdgeInsets.only(top: 20, left: 20),
                                  child: Text(
                                    _doctors[0]['pd_full_name'] == ''
                                        ? ""
                                        : _title == 'None'
                                            ? 'Dr.${_doctors[0]['pd_full_name']} '
                                            : _title +
                                                _doctors[0]['pd_full_name'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 20),
                                  child: Text(
                                    _doctors == []
                                        ? 'Fee Rs: '
                                        : 'Fee Rs.' +
                                            _doctors[0]['appoitmentfee'],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.teal),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    height: 89,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Appointment Duration',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                'Appointment Date',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        VerticalDivider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                _doctors[0]
                                                        ['appoitmentduration'] +
                                                    '  minutes',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.blue.shade900,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                // _date,
                                                '${DateFormat.yMMMMd().format(DateTime.parse(_date.toString()))}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue.shade900,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Your appointment will be scheduled in between',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      '${DateFormat.jm().format(DateFormat('hh:mm:ss').parse(_doctors[0]['mondaystarttiming']))} to ${DateFormat.jm().format(DateFormat('hh:mm:ss').parse(_doctors[0]['mondayofftiming']))}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      right: 190,
                    ),
                    child: Text(
                      'Book Appointment for',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      width: 380,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //const EdgeInsets.fromLTRB(150.0, 8.0, 0.0, 0.0),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: false,
                                items: _appointmentFor.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                hint: Text(_hintText),
                                value: _selectedValue,
                                onChanged: (newvalue) {
                                  setState(() {
                                    _selectedValue = newvalue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        maxLength: 15,
                        controller: _PatientName,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.people_alt,
                            color: Colors.blue,
                          ),
                          hintText: 'Patient Name',
                          hintStyle: TextStyle(fontSize: 18),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Patient Name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        maxLength: 11,
                        controller: _PhoneNumber,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          counterText: '',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Your Phone Number';
                          }
                          if (value.length < 11) {
                            return 'Please Input Your Valid mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          activeColor: Colors.blue,
                          value: Gender.Male,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                              print('Male radio :$_gender');
                            });
                          }),
                      Text('Male'),
                      Radio(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          activeColor: Colors.blue,
                          value: Gender.Female,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                              print('Female radio :$_gender');
                            });
                          }),
                      Text('Female'),
                      Radio(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          activeColor: Colors.blue,
                          value: Gender.Other,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;

                              print('Other radio: $_gender');
                            });
                          }),
                      Text('Others')
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellow.shade700,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20)),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        //alert dialogbox
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("Confirm!"),
                              content:
                                  new Text("Are you sure to book appointment!"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('cancel'),
                                ),
                                new TextButton(
                                  child: new Text("OK"),
                                  onPressed: () async {
                                    /// Navigator.of(context).pop();
                                    if (validate()) {
                                      print(
                                          'Time : ${_doctors[0]['appointmenttime']}');
// notification
                                      List<String> playerID =
                                          await _getPatientPlayerID(0);
                                      for (int i = 0;
                                          i < playerID.length;
                                          i++) {
                                        print(
                                            'Coming Player ID : ${playerID[i]}');
                                      }
                                      await _sendNotification(
                                          playerID, 'You Have New Appointment');
                                      print('_id:$_id');
                                      print('clinicidaftr:$_clinicid');

                                      await addAppointmentData(
                                        GetAppointmentModel(
                                          patientname: _PatientName.text.trim(),
                                          patientphone:
                                              _PhoneNumber.text.trim(),
                                          patientgender: _gender == Gender.Male
                                              ? '1'
                                              : _gender == Gender.Female
                                                  ? '0'
                                                  : '2',
                                          clinic: clinic,
                                          appointmentdate: _date.toString(),
                                          appointmentduration: _doctors[0]
                                              ['appoitmentduration'],
                                          appointmentfor:
                                              _selectedValue == null ||
                                                      _selectedValue == ''
                                                  ? 'Myself'
                                                  : _selectedValue,
                                          appointmenttime:
                                              '${DateFormat.jm().format(DateFormat('hh:mm:ss').parse(_doctors[0]['mondaystarttiming']))} to ${DateFormat.jm().format(DateFormat('hh:mm:ss').parse(_doctors[0]['mondayofftiming']))}',
                                          //'${DateFormat.jm().format(DateFormat("hh:mm:ss").parse(_doctors[0]['mondaystarttiming'],))} to ${DateFormat.jm().format(DateFormat("hh:mm:ss").parse(_doctors[0]['mondaystarttiming'],))}',),
                                          clinicid: _clinicid, //03336102090
                                          docid: uID,
                                          doctorname: _doctors[0]
                                              ['pd_full_name'],
                                          fee: _doctors[0]['appoitmentfee'],
                                          status: 'pending',
                                          puid: _id,
                                          cancelreason: 'not availabel',
                                        ),
                                      );
                                      //Navigator.of(context).pushNamed(

                                      //   PendingAppointmentScreen.routeName);

                                      await Navigator.of(context)
                                          .pushReplacementNamed(
                                              ServicesScreen.routeName,
                                              arguments: {
                                            'index': 1,
                                          });
                                      Navigator.of(context).pop();
                                    } else {
                                      return;
                                    }

                                    // Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: _save
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Book appointment',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
/*

*/