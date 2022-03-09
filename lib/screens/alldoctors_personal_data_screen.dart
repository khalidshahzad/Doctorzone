import 'dart:convert';
import '/exception.dart';
import '/screens/selected_doctor_screen.dart';
import 'package:flutter/cupertino.dart';
import '../model/doctor_personal_data_model.dart';
//import '../services/all_doctors_data_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ip.dart' as Ip;
import 'package:http/http.dart' as http;

class DoctorsProfileScreen2 extends StatefulWidget {
  static const routeName = 'SelectedDoctorsProfile';
  @override
  _DoctorsProfileScreen2State createState() => _DoctorsProfileScreen2State();
}

class _DoctorsProfileScreen2State extends State<DoctorsProfileScreen2> {
  SharedPreferences _loginData;
  // ignore: unused_field
  String _uID;
  bool _loading = true;
  var _sid;
  String _title;
  Map<String, dynamic> _comingData;

  // List<DoctorPersonalData> filteredDoctors = [];
  Map<String, dynamic> filteredDoctors;
  List<DoctorPersonalData> getDoctors = [];

  Future<void> initial() async {
    _loginData = await SharedPreferences.getInstance();
    _uID = _loginData.getString('id');
    // print('uID : $_uID');
  }

  Future<void> getAllDoctorsRecord(_sid) async {
    try {
      final response = await http.post(
          '${Ip.serverip}/RegisterDoctorsaccordService.php',
          body: {'sid': _sid});
      // print('{Sid: $_sid}');
      if (response.statusCode == 200) {
        _comingData = json.decode(response.body);
      }
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }




  @override
  void didChangeDependencies() async {
    // try {
    super.didChangeDependencies();
    await initial();
    await getAllDoctorsRecord(_sid);
    print(_comingData);
    //print('length:${_comingData['doctors'].length}');
    // print(
    //    'User Coming Experience : ${_comingData['doctors'][0]['experiences'][0]['exp_experience_in_years']}');
    setState(() {
      _loading = false;
    });
    // print('Coming Doctors : ${filteredDoctors.length}');
    // } catch (e) {
    //   ShowExceptionDialogBox.showExceptionDialog(context);
    // }
  }

  Widget build(BuildContext context) {
    var sid = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _sid = sid['sid'];
    _title = sid['title'];
    print(_sid);
    print(_title);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
        title: Text(
          '${_title}s',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : (_comingData['doctors'].length == 0)
              ? Column(
                  children: [
                    Container(
                      height: 212,
                      margin: const EdgeInsets.only(top: 100, bottom: 50),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'asset/norec.png',
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      // child: Text('No Doctor Available'),
                    ),
                    Text('No Record Found\nکوئی ریکارڈ نہیں ملا')
                  ],
                )
              : (_loading && _comingData['doctors'].isNotEmpty)
                  ? Center(
                      child: Card(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      child: ListView.builder(
                        itemCount: _comingData['doctors'].length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Container(
                              child: Card(
                                elevation: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          margin: const EdgeInsets.only(
                                              top: 10.0, left: 8, right: 30),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                '${Ip.serverip3}/doctorimg_upload/${_comingData['doctors'][index]['persoanldata'][0]['pd_pic']}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${_comingData['doctors'][index]['persoanldata'][0]['pd_full_name']}',
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: _comingData['doctors']
                                                                  [index]
                                                              ['experiences'] ==
                                                          []
                                                      ? Text('')
                                                      : Text(
                                                          _comingData['doctors']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'experiences'][0]
                                                                  [
                                                                  'total_experience'] +
                                                              //  _comingData['doctors']
                                                              //                 [index][
                                                              //             'experiences'][0]
                                                              //         [
                                                              //         'exp_experience_in_years'] +
                                                              ' Years Experience',
                                                          style: TextStyle(
                                                              color: Colors.teal
                                                                  .shade500),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: _comingData['doctors']
                                                                        [index][
                                                                    'degreename']
                                                                .length ==
                                                            1
                                                        ? Text(
                                                            '${_comingData['doctors'][index]['degreename'][0]['degree']},',
                                                            style: TextStyle(),
                                                          )
                                                        : _comingData['doctors']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'degreename']
                                                                    .length ==
                                                                2
                                                            ? Text('${_comingData['doctors'][index]['degreename'][0]['degree']},' +
                                                                '${_comingData['doctors'][index]['degreename'][1]['degree']},')
                                                            : '${_comingData['doctors'][index]['degreename'][2]['degree']}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    'PMDC # ${_comingData['doctors'][index]['persoanldata'][0]['pd_PMDC']}',
                                                    style: TextStyle(
                                                        color: Colors.teal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 1, right: 40, bottom: 3),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 15),
                                                    primary: Colors.white),
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed(
                                                      SelectedDoctorProfileScreen
                                                          .routeName,
                                                      arguments: {
                                                        'docUID': _comingData[
                                                                'doctors']
                                                            [index]['uID'],
                                                      });
                                                },
                                                child: Text(
                                                  'View Profile',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 1),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                                  primary: Colors.yellow[600]),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    SelectedDoctorProfileScreen
                                                        .routeName,
                                                    arguments: {
                                                      'docUID':
                                                          _comingData['doctors']
                                                              [index]['uID']
                                                    });
                                              },
                                              child: Text('Book Appointment'),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
