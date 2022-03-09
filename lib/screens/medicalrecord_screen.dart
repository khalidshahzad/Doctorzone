import 'dart:convert';
import 'dart:io';
import '../model/medical_model.dart';
import '../services/medical_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ip.dart' as Ip;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MedicalRecordScreen extends StatefulWidget {
  static const routeName = 'medicalrecord';
  const MedicalRecordScreen({Key key}) : super(key: key);

  @override
  _MedicalRecordState createState() => _MedicalRecordState();
}

class _MedicalRecordState extends State<MedicalRecordScreen> {
  SharedPreferences userdata;
  var id;
  bool _isInit = true;
  void didChangeDependencies() async {
    if (_isInit) {
      userdata = await SharedPreferences.getInstance();
      id = userdata.getString('id');
      print('iddddd:$id');
      super.didChangeDependencies();
    }
  }

  bool _editMode = false;
  File _image;
  Future getImagefromgallery() async {
    var imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = File(imageFile.path);
      print('image:$_image');
    });
  }

  Future getImagefromCamera() async {
    var imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = File(imageFile.path);
      print('image:$_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('Medical Record'),
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              // Container(
              //   width: 190,

              (_image == null)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100, left: 100),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                          10,
                          0.0,
                          10.0,
                          0.0,
                        ),
                        height: 250,
                        width: 200,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black45,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.file_present,
                            size: 100,
                          ),
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
                              : (_image ==
                                      null) //if image comming from database is null
                                  ? Image.asset('asset/norec.png')
                                  : Image.network(
                                      '${Ip.serverip}/uploads/}',
                                      fit: BoxFit.cover,
                                    )
                          : _image == null
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
                                      Icons.file_present,
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
                padding: const EdgeInsets.only(left: 100, top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.indigo),
                  child: Text(' تصویر اپ لوڈ کریں/upload picture'),
                  onPressed: () async {
                    print(id);
                    await showModalBottomSheet(
                      context: context,
                      builder: (ctx) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                              onTap: () async {
                                await getImagefromCamera();
                                Navigator.of(context).pop();
                                if (_image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Select Image first',
                                      ),
                                    ),
                                  );

                                  return;
                                }
                                print('puid:$id');
                                await MedicalService().addmedicalrecord(
                                  MedicalModal(
                                      imageBase64: base64Encode(
                                          _image.readAsBytesSync()),
                                      imagename: _image.path.split('/').last,
                                      puid: id),
                                );

                                setState(() {
                                  _image = null;
                                });
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Gallery'),
                              onTap: () async {
                                await getImagefromgallery();
                                print(
                                    'ID After Selecting image from Gallery : $id');
                                Navigator.of(context).pop();
                                if (_image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Select Image first',
                                      ),
                                    ),
                                  );

                                  return;
                                }
                                await MedicalService().addmedicalrecord(
                                  MedicalModal(
                                      imageBase64: base64Encode(
                                          _image.readAsBytesSync()),
                                      imagename: _image.path.split('/').last,
                                      puid: id),
                                );
                                setState(() {
                                  _image = null;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
