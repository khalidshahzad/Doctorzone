import 'dart:convert';
import '/exception.dart';

import '../screens/selected_doctor_screen.dart';
import 'package:http/http.dart' as http;
import '../ip.dart' as Ip;
import 'package:flutter/material.dart';

class AvailAbleDoctorScreen extends StatefulWidget {
  static const routeName = 'available-doctor-screen';
  @override
  _AvailAbleDoctorScreenState createState() => _AvailAbleDoctorScreenState();
}

class _AvailAbleDoctorScreenState extends State<AvailAbleDoctorScreen> {
  // ignore: non_constant_identifier_names

  String query = '';

  final String url1 = '${Ip.serverip}/Doctordata.php';
  var _dctordata;
  bool _isLoading = true;
  // ignore: unused_field
  var _filteredDoctor;
  String _cityID;

  bool _isInit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    try {
      if (_isInit) {
        final data =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        _cityID = data['cityID'];

        await getalldoctor();
      }
      _isInit = false;
      super.didChangeDependencies();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future getalldoctor() async {
    try {
      final response = await http.post(url1, body: {'cityID': _cityID});
      print(_cityID);

      if (response.statusCode == 200) {
        _dctordata = jsonDecode(response.body);
        //   _filteredDoctor = _dctordata;
        print('doctorprofile:$_dctordata');
        return _dctordata;
      }

      return null;
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
      print(e);
    }
  }

  void setResults(String query) {
    _filteredDoctor = _dctordata['doctors']
        .where((elem) => elem['pd_full_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // print('${Ip.serverip}/uploads/${_dctordata['doctors'][0]['pd_pic']}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        automaticallyImplyLeading: true,
        title: Container(
          padding: EdgeInsets.only(left: 50, right: 50),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  onChanged: (string) {
                    if (string.isEmpty) {
                      string = query;
                    }
                    setState(() {
                      query = string;
                      setResults(query);
                      print('filtered Doctors : $_filteredDoctor');
                    });
                  },
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Doctor ",
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _dctordata['doctors'].length == 0
              ? Center(child: Text('No Record found '))
              : query.isEmpty
                  ? ListView.builder(
                      itemCount: _dctordata['doctors'].length,
                      itemBuilder: (ctx, index) {
                        return
                            //Text(
                            ListTile(
                          title: Card(
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
                                        image:
                                            (_dctordata['doctors'].length != 0)
                                                ? NetworkImage(
                                                    '${Ip.serverip3}/doctorimg_upload/${_dctordata['doctors'][index]['pd_pic']}',
                                                  )
                                                : AssetImage(
                                                    'asset/user.png',
                                                  ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            _dctordata['doctors'][index]
                                                ['pd_full_name'],
                                            style:
                                                TextStyle(color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'M.B.B.S, F.C.P.S',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black45),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.all(5),
                                    //   child: Text(
                                    //       '${_dctordata['doctors'][index]['experiences'][index]['exp_experience_in_years']}'),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Text(
                                        _dctordata['doctors'][index]
                                                    ['experiences'] !=
                                                []
                                            ? '${_dctordata['doctors'][index]['experiences'][0]['total_experience']}' +
                                                ' years experience'
                                            : ' yers experience',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.teal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Orthopedic',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black45),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(',General Sergeon')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                SelectedDoctorProfileScreen.routeName,
                                arguments: {
                                  'docUID': _dctordata['doctors'][index]
                                      ['pd_uID']
                                });
                          },
                        ); // _dctordata['personaldata'][index]['fullname']);
                      })
                  : ListView.builder(
                      itemCount: _filteredDoctor.length,
                      itemBuilder: (ctx, index) {
                        //Text('data');
                        return ListTile(
                          title: Card(
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
                                        image: (_filteredDoctor[index]
                                                        ['pd_pic'] !=
                                                    '' ||
                                                _filteredDoctor[index]
                                                        ['pd_pic'] !=
                                                    null)
                                            ? NetworkImage(
                                                '${Ip.serverip3}/doctorimg_upload/${_filteredDoctor[index]['pd_pic']}',
                                              )
                                            : AssetImage(
                                                'asset/user.png',
                                              ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            _filteredDoctor[index]
                                                ['pd_full_name'],
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'M.B.B.S, F.C.P.S',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black45),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 5),
                                      child: Text(
                                        '${_filteredDoctor[index]['experiences'][0]['total_experience']}' +
                                            ' years experience',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.teal.shade500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Orthopedic',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black45),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(',General Sergeon')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                SelectedDoctorProfileScreen.routeName,
                                arguments: {
                                  'docUID': _filteredDoctor[index]['pd_uID']
                                });
                          },
                        );
                        // Text(_filteredDoctor[index]['fullname']);
                      }),
    );
  }
}
