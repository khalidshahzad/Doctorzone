import 'dart:convert';
import 'package:doctorzone/screens/history_appointment_screen.dart';
import 'package:doctorzone/screens/inbox_screen.dart';
import 'package:doctorzone/screens/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/previous_medicalrecord_screen.dart';
import '../services/appointment_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/exception.dart';
import '../urdu_services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../screens/pending_appoitnment_screen.dart';
import 'alldoctors_personal_data_screen.dart';
import '../model/patient_model.dart';
import '../screens/AvailableDoctorScreen.dart';
import '../screens/edit_patient_profile_screen.dart';
import 'patient_profile_screen.dart';
import '../services/patient_profile_services.dart';
import '../model/cities_model.dart';
import 'package:flutter/material.dart';
import '../ip.dart' as IP;
import '../model/available_services_model.dart';
import '../services/fetching_services.dart';
import '../services/get_cities_services.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final String urltotaldctor = '${IP.serverip}/totalregisterdoctor.php';
  SharedPreferences _logindata;

  //bool _flexibleUpdateAvailable = false;
  var _uID;
  var _total;
  var _pic2;
  List<PatientModel> _patientData = [];
  // ignore: unused_field
  String _email;
  String _name;
  PatientModel _allpatientDat;
  List<AvailableServices> services = [];
  bool _isLoading = true;
  String _cityID;
  // ignore: unused_field
  Future<void> _launched;

  List<CityModel> _cities = [];
  // ignore: unused_field
  String _city;
  var _number;
  bool _isInit = true;
  int _currentindex = 0;
  int _comingIndex = 0;
  final List<Widget> _indices = [
    ServicesScreen(),
    PendingAppointmentScreen(),
    //MedicalRecordScreen(),
    PreviousMedicalRecordScreen()
  ];
  var _playerID;

  @override
  void didChangeDependencies() async {
    try {
      if (_isInit) {
        final data =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        if (data != null) {
          _comingIndex = data['index'];
          _currentindex = _comingIndex;
        }
        await initial();
        await getPatientData();
        await getCities();
        await getServices();
        await gettotaldoctornumber();

        await configOneSignal();
        await getPlayerID();
        await registerDevice();
      }
      _isInit = false;
      super.didChangeDependencies();
    } catch (e) {
      print(e);
    }
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> configOneSignal() async {
    if (!mounted) {
      return;
    }

    try {
      await OneSignal.shared.init('ac0d8f95-7843-4615-94d4-69273b872c39');
      OneSignal.shared.setInFocusDisplayType(
        OSNotificationDisplayType.notification,
      );
      await OneSignal.shared.promptUserForPushNotificationPermission(
        fallbackToSettings: true,
      );

      OneSignal.shared.setNotificationReceivedHandler((notification) async {
        print(notification.jsonRepresentation().replaceAll('\\n', '\n'));
      });

      OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
        print('Notification Opened');
      });
    } catch (e) {
      print('OneSignal Exception : ${e.toString()}');
    }

    //
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getpatientpersonaldat() async {
    final response = await http.post(url, body: {'id': _uID});
    if (response.statusCode == 200) {
      print(_uID);
      _allpatientDat = jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<void> getPlayerID() async {
    try {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      _playerID = status.subscriptionStatus.userId;

      print('Player ID : $_playerID');
    } catch (e) {
      print('PlayerID Exception : ${e.toString()}');
    }
  }

  Future<void> registerDevice() async {
    try {
      final registerDeviceURL = '${IP.serverip2}/register_device.php';
      final response = await http.post(
        registerDeviceURL,
        body: {
          'uID': _uID,
          'playerID': _playerID,
        },
      );
      print('Register Response : ${response.body}');
    } catch (e) {
      print('Register Device Exception : ${e.toString()}');
    }
  }

  Future gettotaldoctornumber() async {
    try {
      final response = await http.get(urltotaldctor);
      if (response.statusCode == 200) {
        _number = jsonDecode(response.body);
        print(_number);
        setState(() {
          _total = _number['totaldoctor'].length;
          print('Totalregistersdctr: $_total');
        });
        return _number;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getPatientData() async {
    try {
      _patientData = await PatientProfileServices().getdata(_uID);

      _allpatientDat = _patientData.firstWhere((element) => element.uID == _uID,
          orElse: () => PatientModel());
      _email = _allpatientDat.email;
      _name = _allpatientDat.full_name;
      _pic2 = _allpatientDat.pic;
      print("pic:$_pic2");
    } catch (e) {
      print(e);
    }
  }

  Future initial() async {
    _logindata = await SharedPreferences.getInstance();
    _uID = _logindata.getString('id');
  }

  Future getCities() async {
    try {
      _cities = await Cities().getCites();
      print(_cities.length);
    } catch (e) {
      print(e);
    }
  }

  Future getServices() async {
    try {
      services = await FetchingServices().getServices();
      setState(() {
        _isLoading = false;
      });
      print(services.length);
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        title: Text(
          'DoctorZone',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.indigo.shade900,
                size: 25,
              ),
              // backgroundColor: Colors.indigo.shade900,
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.storage_sharp,
                color: Colors.indigo.shade900,
              ),
              // backgroundColor: Colors.indigo.shade900,
              label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.medical_services_rounded,
                color: Colors.indigo.shade900,
              ),

              // backgroundColor: Colors.indigo.shade900,
              label: 'Medical Record'),
        ],
        onTap: (_indices) {
          setState(() {
            _currentindex = _indices;
          });
        },
      ),
      drawer: Container(
        child: Drawer(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        NetworkImage('${IP.serverip}/uploads/$_pic2', scale: 2),
                    backgroundColor: Colors.white,
                    radius: 50,
                  ),
                  accountEmail: Text(
                    _name == null ? "" : _name.toString(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  accountName: Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.people,
                        size: 25,
                        color: Colors.indigo,
                      ),
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      _allpatientDat != null
                          ? _allpatientDat.uID == null
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => EditUserProfileScreen()))
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ProfileScreen()))
                          : Navigator.of(context).pushReplacementNamed(
                              ServicesScreen.routeName,
                            );
                    }),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.message, color: Colors.indigo),
                title: Text('Inbox'),
                onTap: () {
                  Navigator.of(context).pushNamed(InboxScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.history,
                  color: Colors.indigo,
                ),
                title: Text('History'),
                onTap: () {
                  Navigator.of(context)..pushNamed(HistoryScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Privacy policy'),
                leading: Icon(
                  Icons.home,
                  color: Colors.indigo,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 0,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.indigo,
                    size: 24,
                  ),
                  title: Text(
                    'Log out',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    _logindata.setBool('login', true);

                    _logindata.clear();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignInScreen()));
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 0,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.call,
                    color: Colors.indigo,
                    size: 24,
                  ),
                  title: Text(
                    'Contact Us',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    _launched = _makePhoneCall('tel:03157439959');

                    //Navigator.of(context).pushReplacement(
                    //  MaterialPageRoute(builder: (_) => SignInScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : _currentindex == 0
              ? Stack(
                  children: [
                    Container(
                      height: 190,
                      color: Colors.indigo.shade900,
                    ),

                    // services screen with grid list

                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Container(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: services.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return GridTile(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      DoctorsProfileScreen2.routeName,
                                      arguments: {
                                        'sid': services[index].id,
                                        'title': services[index].service_Name
                                      });
                                },
                                child: Card(
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        height: 45,
                                        width: 50,
                                        child: Image.network(
                                          '${IP.serverip}/ServicesIcons/${services[index].imageURL}',
                                        ),
                                      ),
                                      Text(
                                        services[index].service_Name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        UrduServices().urdu[index],
                                        // services[index].service_name_urdu,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 160, top: 15),
                      child: Container(
                        height: 40,
                        width: 267,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.secondary),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //const EdgeInsets.fromLTRB(150.0, 8.0, 0.0, 0.0),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.add_location,
                                color: Colors.indigo,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  isExpanded: false,
                                  items: _cities == null
                                      ? []
                                      : _cities.map((CityModel value) {
                                          return new DropdownMenuItem<String>(
                                            value: value.city,
                                            child: new Text(value.city),
                                          );
                                        }).toList(),
                                  hint: Text(
                                    'Select City',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (newvalue) {
                                    setState(() {
                                      _city = newvalue;
                                    });
                                    _cityID = _cities == null
                                        ? 1
                                        : _cities
                                            .firstWhere(
                                                (city) => city.city == _city)
                                            .id;
                                  },
                                  value: _city,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 60),
                      child: Text(
                        _total == null
                            ? ""
                            : 'Registered doctors  ${_total.toString()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    //

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 85, left: 10, bottom: 10),
                      child: Container(
                        height: 45,
                        width: 330,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),

                        // child: Padding(
                        //padding: const EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black, decorationThickness: 0),
                          textAlign: TextAlign.center,
                          readOnly: true,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AvailAbleDoctorScreen.routeName,
                                arguments: {
                                  'cityID': _cityID == null ? '0' : _cityID,
                                });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(15),
                            //),
                            hintText: 'Search Doctor',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              color: Colors.indigo,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : _indices[_currentindex],
    );
  }
}
