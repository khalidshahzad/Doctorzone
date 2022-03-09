import 'dart:convert';
import 'dart:io';
import '/exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cities_model.dart';
import '../model/patient_model.dart';
import '../screens/patient_profile_screen.dart';
import '../services/get_cities_services.dart';
import '../services/patient_profile_services.dart';
import '../ip.dart' as Ip;

enum Gender {
  Male,
  Female,
}

class EditUserProfileScreen extends StatefulWidget {
  static const routeName = '/EditPrile';
  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  var textEditingController = TextEditingController(text: "12345678");
  // var maskFormatter = new MaskTextInputFormatter(  //Isko kahin use kiya hoa? ni
  //     mask: 'xxxxx-xxxxxxx-x', filter: {"#": RegExp(r'[0-9]')});
  var _gender = Gender.Female;
  String uID;
  String gender1;
  // ignore: non_constant_identifier_names
  String user_type;
  SharedPreferences _logindata;

  final _formKey = GlobalKey<FormState>();
  String _city;
  String base64Image;
  String errormessage = "erro Upload image";
  // DateTime _isDateTime;
  bool _save = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _whatsapController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cnicController = TextEditingController();
  var _selectedDate;
  num btnValue;

  String _id;
  List<CityModel> _cities;
  List<PatientModel> _allpatientdata;
  PatientModel _patientData;
  bool _isLoading = true;
  File _image;
  final picker = ImagePicker();
  String imageName;
  bool _editMode = false;
  bool _isInit = true;
  String _gender2;
  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    try {
      if (_isInit) {
        await initial();
        await getCities();
        await getPatientData();
      }
      _isInit = false;
      super.didChangeDependencies();
    } catch (e) {
      print(e);
    }
  }

  Future getCities() async {
    try {
      _cities = await Cities().getCites();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future getPatientData() async {
    try {
      _allpatientdata = await PatientProfileServices().getdata(uID);
      _patientData = _allpatientdata.firstWhere((patdata) => patdata.uID == uID,
          orElse: () => null);
      print('Filtered Patient : ${_patientData.toString()}');
      if (_patientData != null) {
        _editMode = true;
        setState(() {
          _id = _patientData.id.toString();
          _nameController.text = _patientData.full_name;
          _whatsapController.text = _patientData.whatsapp;
          _cnicController.text = _patientData.CNIC;
          _emailController.text = _patientData.email.toString();
          _addressController.text = _patientData.address;
          _mobileController.text = _patientData.cell_no;

          _selectedDate = _patientData.date_of_Birth.toString();
          if (_patientData.gender == '1') {
            setState(() {
              _gender = Gender.Male;
            });
          } else {
            setState(() {
              _gender = Gender.Female;
            });
          }
          setState(() {});
          _city = _cities
              .firstWhere((element) => element.id == _patientData.city,
                  orElse: () => CityModel())
              .city;
        });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  Future initial() async {
    _logindata = await SharedPreferences.getInstance();
    uID = _logindata.getString('id');
    user_type = _logindata.getString("user_type");
  }

  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cnicController.dispose();
    _whatsapController.dispose();
    _mobileController.dispose();

    super.dispose();
  }

  // ignore: non_constant_identifier_names
  void getImage_From_Gallery() async {
    var imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = File(imageFile.path);
    });
  }

  void getImagefromCamera() async {
    var imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : Container(
              // padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: [
                            // Container(
                            //   width: 190,

                            (_image == null)
                                ? Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      0.0,
                                      10.0,
                                      0.0,
                                    ),
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black45,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Feather.user,
                                        size: 100,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    width: 150,
                                    child: _editMode
                                        ? _image != null
                                            ? Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              )
                                            : (_patientData.pic == '' ||
                                                    _patientData.pic ==
                                                        null) //if image comming from database is null
                                                ? Image.asset('asset/user.png')
                                                : Image.network(
                                                    '${Ip.serverip}/uploads/${_patientData.pic}',
                                                    fit: BoxFit.cover,
                                                  )
                                        : _image == null
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  10,
                                                  0.0,
                                                  10.0,
                                                  0.0,
                                                ),
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  // shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.black45,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Feather.user,
                                                    size: 100,
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              ),
                                  ),

                            //
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo),
                                  child: Text(' تصویر اپ لوڈ کریں'),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) => SafeArea(
                                        child: Wrap(
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.camera_alt),
                                              title: Text('Camera'),
                                              onTap: () async {
                                                getImagefromCamera();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.photo),
                                              title: Text('Gallery'),
                                              onTap: () async {
                                                getImage_From_Gallery();
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 150, right: 5, top: 20),
                          child: Row(
                            children: [
                              Text("یہ فارم میں درکار ہے"),
                              Text(
                                '*',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            maxLength: 15,
                            textCapitalization: TextCapitalization.characters,
                            controller: _nameController,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                              labelText: '*FullName/پورا نام',
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "براہ مہربانی اپنا نام درج کریں";
                              }
                              if (value.length < 3) {
                                return "آپ کا نام کم از کم تین الفاز ہونا چاہئے";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Gender :',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Radio(
                              activeColor: Colors.blueAccent,
                              value: Gender.Male,
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            Text('Male'),
                            Radio(
                              activeColor: Colors.blueAccent,
                              value: Gender.Female,
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            Text('Female'),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Date Of Birth:",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo),
                                child: _selectedDate == 'null'
                                    ? Text('تاریخ پیدائش منتخب کریں')
                                    : Text(_selectedDate.toString()),
                                onPressed: () async {
                                  await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1947),
                                          lastDate: DateTime.now())
                                      .then((pickedDate) {
                                    setState(() {
                                      _selectedDate = DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                      //yyyy/mm//dd
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email/ای میل',
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            maxLength: 11,
                            controller: _mobileController,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                              labelText: '*Mobile Number/موبائل نمبر',
                              prefixIcon: Icon(Icons.mobile_friendly),
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "درست موبائل نمبر درج کریں";
                              }
                              if (value.length < 11) {
                                return "درست موبائل نمبر درج کریں";
                              }
                              if (value.length > 11) {
                                return "درست موبائل نمبر درج کریں";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            maxLength: 11,
                            controller: _whatsapController,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                              labelText: 'WhatsApp Number/واٹس ایپ نمبر',
                              prefixIcon: Icon(FontAwesome.whatsapp),
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return " درست واٹس ایپ نمبر درج کریں";
                              }
                              if (value.length < 11) {
                                return "درست واٹس ایپ نمبر درج کریں";
                              }
                              if (value.length > 11) {
                                return "درست واٹس ایپ نمبر درج کریں";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            maxLength: 13,
                            controller: _cnicController,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                              labelText:
                                  '*Enter CNIC Number/قومی شناختی نمبر درج کریں',
                              prefixIcon: Icon(FontAwesome.id_card),
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              String pattern = r'^[0-9]{5}[0-9]{7}[0-9]{1}$';
                              RegExp regExp = RegExp(pattern);
                              if (!regExp.hasMatch(value)) {
                                return 'براہ کرم درست قومی شناختی کارڈ نمبر درج کریں';
                              }
                              if (value.isEmpty) {
                                return "براہ کرم درست قومی شناختی کارڈ نمبر درج کریں";
                              }
                              if (value.length < 13) {
                                return "آپ کا قومی شناختی کارڈ نمبر 13 کی حد میں ہونا چاہئے";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 325,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(Icons.add_location, color: Colors.blue),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 4, right: 6, bottom: 2),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    items: _cities == null
                                        ? []
                                        : _cities.map((CityModel value) {
                                            return new DropdownMenuItem<String>(
                                              value: value.city,
                                              child: new Text(value.city),
                                            );
                                          }).toList(),
                                    hint: Text('Select City/شہر منتخب کریں'),
                                    onChanged: (newvalue) {
                                      setState(() {
                                        _city = newvalue;
                                      });
                                    },
                                    value: _city,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address/پتہ درج کریں',
                                labelStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                prefixIcon: Icon(
                                  Icons.add_location_alt,
                                  color: Colors.blue,
                                )),
                          ),
                        ),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.indigo),
                          onPressed: () async {
                            final isValid = _formKey.currentState.validate();

                            if (!isValid) {
                              return null;
                            }
                            (_editMode == true && _image == null)
                                ? imageName = ''
                                : _image == null
                                    ? imageName = ''
                                    : imageName = _image.path.split('/').last;

                            if (_gender == Gender.Male) {
                              gender1 = '1';
                            } else {
                              gender1 = '0';
                            }
                            if (_editMode == false && _patientData == null) {
                              String cityID = _cities
                                  .firstWhere((city) => city.city == _city)
                                  .id;

                              var imageString =
                                  base64Encode(_image.readAsBytesSync());

                              await PatientProfileServices().addPatientData(
                                PatientModel(
                                  uID: uID,
                                  full_name: _nameController.text.trim(),
                                  gender: gender1,
                                  email: _emailController.text.trim(),
                                  cell_no: _mobileController.text.trim(),
                                  whatsapp: _whatsapController.text.trim(),
                                  address: _addressController.text.trim(),
                                  CNIC: _cnicController.text.trim(),
                                  pic: _image != null ? imageName : '',
                                  picBase64: _image != null ? imageString : '',
                                  country: '137',
                                  city: cityID,
                                  date_of_Birth: _selectedDate.toString(),
                                  // userType: user_type,
                                ),
                              );
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(ProfileScreen.routeName);
                            } else if (_editMode == true) {
                              print('Edit Mode:true');
                              String cityID = _cities
                                  .firstWhere((city) => city.city == _city)
                                  .id;

                              if (_gender == Gender.Male) {
                                _gender2 = '1';
                              } else {
                                _gender2 = '0';
                              }
                              await PatientProfileServices().upDatePatientData(
                                  PatientModel(
                                      id: _id,
                                      uID: uID,
                                      full_name: _nameController.text.trim(),
                                      gender: _gender2.toString(),
                                      email: _emailController.text.trim(),
                                      cell_no: _mobileController.text.trim(),
                                      CNIC: _cnicController.text.trim(),
                                      address: _addressController.text.trim(),
                                      whatsapp: _whatsapController.text.trim(),
                                      date_of_Birth: _selectedDate.toString(),
                                      city: cityID,
                                      country: '137',
                                      // userType: user_type,
                                      pic: _image == null
                                          ? (_patientData.pic == null ||
                                                  _patientData.pic == '')
                                              ? ''
                                              : _patientData.pic
                                          : imageName,
                                      picBase64: _image != null
                                          ? base64Encode(
                                              _image.readAsBytesSync())
                                          : ''));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(ProfileScreen.routeName);
                            }
                          },
                          child: Container(
                            width: 100,
                            child: Center(
                              child: _save
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.grey,
                                    )
                                  : _editMode == true
                                      ? Text(
                                          'Update',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          softWrap: false,
                                        )
                                      : Text(
                                          'Save',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
