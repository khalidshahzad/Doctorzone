import 'package:intl/intl.dart';

import '../model/cities_model.dart';
import '../model/patient_model.dart';
import '../services/get_cities_services.dart';
import '../services/patient_profile_services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../ip.dart' as IP;
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_patient_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String urlgetpatientdata = '${IP.serverip}/FetchProfile.php';
  // ignore: non_constant_identifier_names
  String pic_url;
  SharedPreferences _logindata;
  //
  String _gender;
  String _email;
  // ignore: unused_field
  String _fullname;
  // ignore: non_constant_identifier_names
  String _date_Of_Birht;
  // ignore: non_constant_identifier_names
  String _cell_no;
  // ignore: non_constant_identifier_names
  String _whatsapp_no;
  // ignore: non_constant_identifier_names
  String _CNIC;
  // ignore: unused_field
  String _city = '';
  String _address;

  String uID;
  List<CityModel> _cities = [];
  //
  bool _isLoading = true;
  List<PatientModel> _patientData;
  PatientModel _allpatientData;
  bool _isInit = true;
  //
  // ignore: non_constant_identifier_names
  String user_type;
  @override
  void initState() {
    super.initState();
  }

  // Future<void> getpatientpersonaldat() async {
  //   final response = await http.post(urlgetpatientdata, body: {'id': uID});
  //   if (response.statusCode == 200) {
  //     print('uid:$uID');
  //     _allpatientData = jsonDecode(response.body);
  //     print(_allpatientData);
  //   } else {
  //     return [];
  //   }
  // }

  @override
  void didChangeDependencies() async {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    print('Doctor coming data : $data');
    if (_isInit) {
      await initial();
      // await getpatientpersonaldat();
      await patientData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future initial() async {
    _logindata = await SharedPreferences.getInstance();
    uID = _logindata.getString('id');
    user_type = _logindata.getString("user_type");
    print('UID : $uID');
    print('User Type : $user_type');
  }

  Future patientData() async {
    _patientData = await PatientProfileServices().getdata(uID);

    _allpatientData = _patientData.firstWhere((element) => element.uID == uID,
        orElse: () => PatientModel());
    _cities = await Cities().getCites();

    _city = _cities
        .firstWhere((element) => element.id == _allpatientData.city,
            orElse: () => CityModel())
        .city;
    print('City : $_city'.toString());
    if (_allpatientData.id != null) {
      setState(() {
        if (_allpatientData.gender == '1') {
          setState(() {
            _gender = "Male";
          });
        } else {
          setState(() {
            _gender = "Female";
          });
        }
      });

      _CNIC = _allpatientData.CNIC.toString();
      _cell_no = _allpatientData.cell_no.toString();
      _fullname = _allpatientData.full_name.toString();
      _whatsapp_no = _allpatientData.whatsapp.toString();
      _email = _allpatientData.email.toString();
      _address = _allpatientData.address.toString();
      _date_Of_Birht = _allpatientData.date_of_Birth.toString();
      pic_url = "${IP.serverip}/uploads/${_allpatientData.pic}";
      print('pic : ${_allpatientData.pic}');
      print(_allpatientData.whatsapp);
    }
    setState(() {
      _isLoading = false;
    });
    print(_allpatientData.CNIC);
  }

  Widget getRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            maxLines: 2,
            style: TextStyle(fontSize: 19, color: Colors.black),
            overflow: TextOverflow.clip,
          ),
        ),
        Expanded(
          child: Text(
            value,
            //textDirection: TextDirection.rtl,
            //maxLines: 2,
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(200, 10, 50, 10),
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        title: Text(
          ' Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //Image and Name

                  Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      //border: Border.all(),
                      color: Colors.indigo.shade900,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //
                        Container(
                          width: 150,
                          height: 145,
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.white,
                            image: DecorationImage(
                                image: (_allpatientData.pic != '' ||
                                        _allpatientData.pic != null)
                                    ? NetworkImage(
                                        pic_url,
                                      )
                                    : AssetImage(
                                        'asset/user.png',
                                      ),
                                fit: BoxFit.fitWidth),
                          ),
                        ),

                        InkWell(
                          hoverColor: Colors.white,
                          child: Icon(
                            FontAwesome.edit, size: 23, color: Colors.white,
                            // 'Edit Profile',
                            // style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditUserProfileScreen()));
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            _fullname == null ? '' : _fullname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Personal

                  DataTable(
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
                          DataCell(Text('Gender')),
                          DataCell(
                            Text(
                              '$_gender'.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              'Date of Birth ',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          DataCell(
                            _date_Of_Birht == 'null'
                                ? Text('')
                                : Text(
                                    '${DateFormat.yMMMMd().format(
                                          DateTime.parse(_date_Of_Birht),
                                        ).toString()}',
                                    style: TextStyle(
                                        fontSize: 15,
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
                              'Phone Number',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          DataCell(
                            Text('$_cell_no'.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text('Whatsapp'),
                          ),
                          DataCell(
                            _whatsapp_no == 'null'
                                ? Text('')
                                : Text(
                                    '$_whatsapp_no'.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text('CNIC'),
                          ),
                          DataCell(
                            _CNIC == 'null'
                                ? Text('')
                                : Text(
                                    '$_CNIC'.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text('Email'),
                          ),
                          DataCell(
                            _email == 'null'
                                ? Text('')
                                : Text(
                                    '$_email'.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text('Address'),
                          ),
                          DataCell(
                            _address == 'null'
                                ? Text('')
                                : Text(
                                    '$_address'.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
