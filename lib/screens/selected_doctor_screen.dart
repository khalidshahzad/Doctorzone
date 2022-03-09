// ignore_for_file: unused_import

import 'dart:convert';
import 'package:doctorzone/screens/chat_screen.dart';
import 'package:doctorzone/screens/inbox_screen.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '/exception.dart';

// import '../screens/googlemap_screen.dart';
import '../screens/appointment_screen.dart';
import '../model/selected_doctor_complete_profile_modal.dart';
import '../model/cities_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;

enum Gender { Male, Female }

// SER.serviceID=2
class SelectedDoctorProfileScreen extends StatefulWidget {
  static const routeName = 'SelectedDoctorProflile';

  @override
  _SelectedDoctorProfileScreenState createState() =>
      _SelectedDoctorProfileScreenState();
}

class _SelectedDoctorProfileScreenState
    extends State<SelectedDoctorProfileScreen> {
  final String url = '${Ip.serverip}/doctorprofiledata.php';

  // ignore: non_constant_identifier_names
  String pic_url;
  var _data;
  Future getprofile() async {
    try {
      final response = await http.post(url, body: {'uID': uID});
      print(uID);
      if (response.statusCode == 200) {
        print('doctorprofile:$response');
        _data
        
         = jsonDecode(response.body);
        print('doctorprofile:$_data');
        return _data;
      }
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }

    return null;
  }
  //

  // ignore: unused_field
  String _city = '';
  // ignore: unused_field
  String _address;
  String uID;
  // ignore: unused_field
  List<CityModel> _cities = [];
  //
  bool _isServicesExpanded = false;
  bool _isEducationExpanded = false;
  bool _isSpecializationExpanded = false;
  bool _isprofessionalMemberShipExpanded = false;
  bool _isLoading = true;
  bool _isInit = true;
  // ignore: unused_field
  List<SelectedDoctorProfileModel> _doctors = [];
  // ignore: unused_field
  Future<void> _launched;
  // ignore: non_constant_identifier_names
  String user_type;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    try {
      final _uID =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      setState(() {
        uID = _uID['docUID'];
      });

      print('Doctor id called : ${_uID['docUID']}');
      if (_isInit) {
        await getprofile();
        //await doctorsData();
        // await getClinicData();print(_data['clinicofdoctor'].length);

      }
    } catch (e) {
      print(e);
      //
    }
    print(_data['clinicofdoctor'].length);
    print(_data['clinicofdoctor']);
    super.didChangeDependencies();
    _isInit = false;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget getRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 19, color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(200, 10, 50, 10),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text(
          ' Doctor Profle',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                Container(
                  height: size.height - 132,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        elevation: 1,
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(
                                  bottom: 30, left: 8, right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                    scale: 1,
                                    image: (_data == [] || _data == null)
                                        ? AssetImage(
                                            'asset/user.png',
                                          )
                                        : NetworkImage(
                                            '${Ip.serverip3}/doctorimg_upload/${_data['basic_detail'][0]['pd_pic']}',
                                          ),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 83),
                                child: Column(
                                  children: [],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        _data['basic_detail'].length == 0
                                            ? ""
                                            : _data['basic_detail'][0]
                                                ['pd_full_name'],
                                        style: TextStyle(color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _data['educationofdoctor'].length ==
                                                    0
                                                ? ''
                                                : _data['educationofdoctor']
                                                            .length ==
                                                        1
                                                    ? '${_data['educationofdoctor'][0]['degreeName']}'
                                                    : _data['educationofdoctor']
                                                                .length ==
                                                            2
                                                        ? '${_data['educationofdoctor'][0]['degreeName']}, ${_data['educationofdoctor'][1]['degreeName']}'
                                                        : _data['educationofdoctor']
                                                                    .length ==
                                                                3
                                                            ? '${_data['educationofdoctor'][0]['degreeName']}, ${_data['educationofdoctor'][1]['degreeName']}, ${_data['educationofdoctor'][2]['degreeName']}'
                                                            : '',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Row(
                                    children: [
                                      Text(_data['servicesofdoctors'].length ==
                                              0
                                          ? ""
                                          : _data['servicesofdoctors'].length ==
                                                  1
                                              ? '${_data['servicesofdoctors'][0]['services']}'
                                              : _data['servicesofdoctors']
                                                          .length ==
                                                      2
                                                  ? '${_data['servicesofdoctors'][0]['services']},${_data['servicesofdoctors'][1]['services']}'
                                                  : _data['servicesofdoctors']
                                                              .length ==
                                                          3
                                                      ? '${_data['servicesofdoctors'][0]['services']},${_data['servicesofdoctors'][1]['services']},${_data['servicesofdoctors'][2]['services']}'
                                                      : '${_data['servicesofdoctors'][0]['services']},${_data['servicesofdoctors'][1]['services']},${_data['servicesofdoctors'][2]['services']},${_data['servicesofdoctors'][3]['services']}'),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child:
                                        _data['experiencesofdoctor'].length == 0
                                            ? Text('')
                                            : Text(
                                                _data['experiencesofdoctor'][0]
                                                        ['exp_in_years'] +
                                                    ' Years Experience',
                                                style: TextStyle(
                                                    color:
                                                        Colors.teal.shade600),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: _data['basic_detail'][0]
                                              ['pmdcregistrationno'] !=
                                          null
                                      ? Text(
                                          'PMDC#  ${_data['basic_detail'][0]['pmdcregistrationno']}'
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.teal.shade600),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(''),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ), //card for patient feedback about doctor

                      SizedBox(
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.feedback_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Patient Feedback',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 20),
                                    child: Text('Overall Experience'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.star_sharp,
                                      color: Colors.yellow[600],
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 20),
                                    child: Text('Doctor Checkup'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 34),
                                    child: Icon(
                                      Icons.star_sharp,
                                      color: Colors.yellow[600],
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 20),
                                    child: Text('Staff Behaviour'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 38),
                                    child: Icon(
                                      Icons.star_sharp,
                                      color: Colors.yellow[600],
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 20, bottom: 5),
                                    child: Text('Clinic Environment'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.star_sharp,
                                      color: Colors.yellow[600],
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    color: Colors.yellow[600],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add_location_alt_rounded,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Practice Locations',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _data['clinicofdoctor'].length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          AppointmentScreen.routeName,
                                          arguments: {
                                            'clinicData':
                                                _data['clinicofdoctor'][index],
                                            // 'dtitle': _data['basic_detail'][1]
                                            //     ['title'],
                                            // 'clinicname':
                                            //     _data['clinicofdoctor'][index]
                                            //         ['clinic'],
                                            // 'docid': _data['clinicofdoctor']
                                            //     [index]['docid'],
                                            'clinicid': _data['clinicofdoctor']
                                                [index]['clinicids'],
                                          });
                                      print(_data['clinicofdoctor'][index]
                                          ['clinic']);
                                    },
                                    title: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            _data['clinicofdoctor'][index]
                                                ['clinic'],
                                            maxLines: 2,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Colors.teal.shade600),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          _data['clinicofdoctor'][index]
                                              ['address'],
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0),
                                              child: Text(
                                                'Fee Rs :${_data['clinicofdoctor'][index]['appoitmentfee']}',
                                                style: TextStyle(
                                                    color:
                                                        Colors.teal.shade600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          textBaseline: TextBaseline.alphabetic,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                _data['clinicofdoctor'][index]
                                                            ['mondaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text('Monday'),
                                                _data['clinicofdoctor'][index]
                                                            ['mondaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text(
                                                        '${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'mondaystarttiming'],
                                                          ),
                                                        )} to ${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'mondayofftiming'],
                                                          ),
                                                        )}',
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _data['clinicofdoctor'][index]
                                                            ['tuesdaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text('Tuesday'),
                                                _data['clinicofdoctor'][index]
                                                            ['tuesdaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text(
                                                        '${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'tuesdaystarttiming'],
                                                          ),
                                                        )} to ${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'tuesdayofftiming'],
                                                          ),
                                                        )}',
                                                      ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _data['clinicofdoctor'][index]
                                                              [
                                                              'wednesdaystatus'] ==
                                                          'off'
                                                      ? Text('')
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child:
                                                              Text('Wednesday'),
                                                        ),
                                                  _data['clinicofdoctor'][index]
                                                              [
                                                              'wednesdaystatus'] ==
                                                          'off'
                                                      ? Text('')
                                                      : Text(
                                                          '${DateFormat.jm().format(
                                                            DateFormat(
                                                                    'hh:mm:ss')
                                                                .parse(
                                                              _data['clinicofdoctor']
                                                                      [index][
                                                                  'wednesdaystarttiming'],
                                                            ),
                                                          )} to ${DateFormat.jm().format(
                                                            DateFormat(
                                                                    'hh:mm:ss')
                                                                .parse(
                                                              _data['clinicofdoctor']
                                                                      [index][
                                                                  'wednesdayofftiming'],
                                                            ),
                                                          )}',
                                                        ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _data['clinicofdoctor'][index][
                                                            'thursdaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text('Thursday'),
                                                _data['clinicofdoctor'][index][
                                                            'thursdaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text(
                                                        '${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'thursdaystarttiming'],
                                                          ),
                                                        )} to ${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'thursdayofftiming'],
                                                          ),
                                                        )}',
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _data['clinicofdoctor'][index]
                                                            ['fridaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text('Friday'),
                                                _data['clinicofdoctor'][index]
                                                            ['fridaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text(
                                                        '${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'fridaystarttiming'],
                                                          ),
                                                        )} to ${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'fridayofftiming'],
                                                          ),
                                                        )}',
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _data['clinicofdoctor'][index][
                                                            'saturdaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text('Saturday'),
                                                _data['clinicofdoctor'][index][
                                                            'saturdaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text(
                                                        '${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'saturdaystarttiming'],
                                                          ),
                                                        )} to ${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'saturdayofftiming'],
                                                          ),
                                                        )}',
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _data['clinicofdoctor'][index]
                                                            ['sundaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text('Sunday'),
                                                _data['clinicofdoctor'][index]
                                                            ['sundaystatus'] ==
                                                        'off'
                                                    ? Text('')
                                                    : Text(
                                                        '${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'sundaystarttiming'],
                                                          ),
                                                        )} to ${DateFormat.jm().format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(
                                                            _data['clinicofdoctor']
                                                                    [index][
                                                                'sundayofftiming'],
                                                          ),
                                                        )}',
                                                      ),
                                              ],
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.message,
                                                color: Colors.blue,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  ChatScreen.routeName,
                                                  arguments: {
                                                    'doctorID':
                                                        _data['clinicofdoctor']
                                                            [0]['docid'],
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 3,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      //card for servic
                      //es /list of diseases treated

                      SizedBox(
                        // height: _isServicesExpanded ? 250 : 60,
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.medical_services,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Clinical Services',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isServicesExpanded =
                                              !_isServicesExpanded;
                                        });
                                      },
                                      icon: Icon(
                                        _isServicesExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _isServicesExpanded
                                  ? Container(
                                      height: 180,
                                      child: _data['clinicalservices'].length ==
                                              0
                                          ? Center(
                                              child:
                                                  Text('No service Available'))
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  _data['clinicalservices']
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(
                                                      '. ${_data['clinicalservices'][index]['serviceName']}'),
                                                );
                                              }),
                                    )
                                  : Container(
                                      height: 5,
                                    ),
                            ],
                          ),
                        ),
                      ), //Diiseases Treated
                      SizedBox(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.list,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Diseases Treated',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _data['disease'].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                                '. ${_data['disease'][index]['diseaseName']}')
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //card for Others information

                      Card(
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.info,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Other Information',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _isEducationExpanded
                                    ? Container(
                                        child: Expanded(
                                          child: SizedBox(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  _data['educationofdoctor']
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5.0,
                                                              top: 5.0),
                                                      child: Text(_data['educationofdoctor']
                                                                      .length ==
                                                                  0 ||
                                                              _data['educationofdoctor']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'degreeName'] ==
                                                                  'none'
                                                          ? ""
                                                          : '. ${_data['educationofdoctor'][index]['degreeName']}'),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Text('Education'),
                                        height: 30,
                                      ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEducationExpanded =
                                          !_isEducationExpanded;
                                    });
                                  },
                                  icon: Icon(
                                    _isEducationExpanded
                                        ? Icons.remove
                                        : Icons.add_sharp,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _isSpecializationExpanded
                                    ? Container(
                                        child: Expanded(
                                          child: SizedBox(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    _data['servicesofdoctors']
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                            '. ${_data['servicesofdoctors'][index]['services']}')
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Text('Specialization'),
                                        height: 20,
                                      ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSpecializationExpanded =
                                          !_isSpecializationExpanded;
                                    });
                                  },
                                  icon: Icon(
                                    _isSpecializationExpanded
                                        ? Icons.remove
                                        : Icons.add_sharp,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isprofessionalMemberShipExpanded
                                    ? Container(
                                        child: Expanded(
                                          child: SizedBox(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    _data['membershipofdoctor']
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Row(
                                                      children: [
                                                        Text(_data['membershipofdoctor']
                                                                    .length ==
                                                                0
                                                            ? ""
                                                            : '${_data['membershipofdoctor'][index]['society']}')
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 20,
                                        child: Text('Professionalmembership'),
                                      ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isprofessionalMemberShipExpanded =
                                          !_isprofessionalMemberShipExpanded;
                                    });
                                  },
                                  icon: Icon(
                                    _isprofessionalMemberShipExpanded
                                        ? Icons.remove
                                        : Icons.add_sharp,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        // height: 250,
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.people,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 5),
                                          child: Text(
                                            'About',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 10, bottom: 10),
                                      child: Text(
                                          '${_data['basic_detail'][0]['pd_professional_Statement']}'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          primary: Colors.blue.shade900),
                      onPressed: () async {
                        setState(() async {
                          _launched = _makePhoneCall('tel:03157439959');
                        });
                        // Navigator.of(context)
                        //     .popAndPushNamed(TestScreen.routeName);
                      },
                      child: Text('Helpline'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 48, vertical: 14),
                          primary: Colors.yellow.shade600),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Card(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  itemCount: _data['clinicofdoctor'].length,
                                  itemBuilder: (contex, index) {
                                    print(
                                        'modalbottommsheet${_data['clinicofdoctor'].length}');
                                    return ListTile(
                                      title: Container(
                                        child: _data['clinicofdoctor'].length ==
                                                0
                                            ? Center(
                                                child:
                                                    Text('No Clinic Scheduled'),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                      _data['clinicofdoctor']
                                                          [index]['clinic'],
                                                      style: TextStyle(
                                                          color: Colors
                                                              .teal.shade600),
                                                      softWrap: true,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    _data['clinicofdoctor']
                                                        [index]['address'],
                                                    softWrap: true,
                                                    maxLines: 2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Text(
                                                          'Fee Rs :${_data['clinicofdoctor'][index]['appoitmentfee']}',
                                                          style: TextStyle(
                                                              color: Colors.teal
                                                                  .shade600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      DataTable(
                                                        columns: [
                                                          DataColumn(
                                                            label: Text(''),
                                                          ),
                                                          DataColumn(
                                                            label: Text(''),
                                                          ),
                                                        ],
                                                        rows: <DataRow>[
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'mondaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Monday'),
                                                              ),
                                                              DataCell(
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                                  child: _data['clinicofdoctor'][index]
                                                                              [
                                                                              'mondaystatus'] ==
                                                                          'off'
                                                                      ? Text('')
                                                                      : Text(
                                                                          '${DateFormat.jm().format(
                                                                            DateFormat('hh:mm:ss').parse(
                                                                              _data['clinicofdoctor'][index]['mondaystarttiming'],
                                                                            ),
                                                                          )} to ${DateFormat.jm().format(
                                                                            DateFormat('hh:mm:ss').parse(
                                                                              _data['clinicofdoctor'][index]['mondayofftiming'],
                                                                            ),
                                                                          )}',
                                                                        ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'tuesdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Tuesday'),
                                                              ),
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'tuesdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        '${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['tuesdaystarttiming'],
                                                                          ),
                                                                        )} to ${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['tuesdayofftiming'],
                                                                          ),
                                                                        )}',
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'wednesdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Wednesday'),
                                                              ),
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'wednesdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        '${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['wednesdaystarttiming'],
                                                                          ),
                                                                        )} to ${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['wednesdayofftiming'],
                                                                          ),
                                                                        )}',
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'thursdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Thursday'),
                                                              ),
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'thursdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        '${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['thursdaystarttiming'],
                                                                          ),
                                                                        )} to ${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['thursdayofftiming'],
                                                                          ),
                                                                        )}',
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'fridaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Friday'),
                                                              ),
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'fridaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        '${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['fridaystarttiming'],
                                                                          ),
                                                                        )} to ${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['fridayofftiming'],
                                                                          ),
                                                                        )}',
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'saturdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Saturday'),
                                                              ),
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'saturdaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        '${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['saturdaystarttiming'],
                                                                          ),
                                                                        )} to ${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['saturdayofftiming'],
                                                                          ),
                                                                        )}',
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'sundaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        'Sunday'),
                                                              ),
                                                              DataCell(
                                                                _data['clinicofdoctor'][index]
                                                                            [
                                                                            'sundaystatus'] ==
                                                                        'off'
                                                                    ? Text('')
                                                                    : Text(
                                                                        '${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['sundaystarttiming'],
                                                                          ),
                                                                        )} to ${DateFormat.jm().format(
                                                                          DateFormat('hh:mm:ss')
                                                                              .parse(
                                                                            _data['clinicofdoctor'][index]['sundayofftiming'],
                                                                          ),
                                                                        )}',
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(thickness: 3),
                                                ],
                                              ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            AppointmentScreen.routeName,
                                            arguments: {
                                              'clinicData':
                                                  _data['clinicofdoctor']
                                                      [index],
                                              //'dtitle': _data['basic_detail'][1]
                                              //   ['title'],
                                              'clinicid':
                                                  _data['clinicofdoctor'][index]
                                                      ['clinicids'],
                                            });
                                        print(_data['clinicofdoctor'][index]
                                            ['clinic']);
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('Book Appointment'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
