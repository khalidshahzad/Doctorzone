import '../exception.dart';

import '../screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../services/sign_up_services.dart';
import '../model/sign_up_model.dart';

enum Gender {
  Male,
  Female,
  Other,
}

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  var _gender = Gender.Male;

  final _fromKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _save = false;

  String _message;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  //Dr. Muhammad Farooq Khan Niazi

  add(SignUpModel signUpModel) async {
    try {
      setState(() {
        _save = true;
      });
      _message = await SignUpServices().addUser(signUpModel);
      setState(() {
        _save = false;
      });
      if (_message == 'Record Already Exists') {
        Toast.show('صارف کا نام پہلے سے موجود ہے', context,
            duration: 5, gravity: Toast.BOTTOM);
      } else {
        Toast.show(
            'you have signup sucessfully\nآپ نے کامیابی کے ساتھ سائن اپ کیا ہے۔',
            context,
            duration: 5,
            gravity: Toast.BOTTOM);
      }
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            color: Colors.indigo.shade900,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 140,
              ),
              child: Text(
                'Create Your Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _fromKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: TextFormField(
                                    maxLength: 11,
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      counterText: '',
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      labelText: 'فون نمبر',
                                      hintText: '03123456789',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter phone number/فون نمبر';
                                      }
                                      if (value.length < 11) {
                                        return 'Please enter valid phone number \n براہ کرم اپنا فون نمبر درج کریں';
                                      }

                                      //Checking Username

                                      //

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: TextFormField(
                                    maxLength: 20,
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      counterText: '',
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      labelText:
                                          'Enter Your Full Name/اپنا پورا نام درج کریں',
                                      hintText: '',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.people,
                                        color: Colors.indigo.shade500,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter full name';
                                      }
                                      if (value.length <= 2) {
                                        return 'Please enter valid full name';
                                      }

                                      //Checking Username

                                      //

                                      return null;
                                    },
                                    keyboardType: TextInputType.name,
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 8, bottom: 8),
                                  child: TextFormField(
                                    maxLength: 25,
                                    controller: _passwordController,
                                    obscureText: _hidePassword,
                                    focusNode: _passwordFocusNode,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      labelText: 'Password /پاسورڈ   ',
                                      counterText: '',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.indigo.shade500,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(_hidePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                          _confirmPasswordFocusNode);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'براہ کرم پاس ورڈ درج کریں۔';
                                      }

                                      if (value.length <= 6) {
                                        return 'براہ مہربانی چھ حروف سے زیادہ پاس ورڈ درج کریں۔';
                                      }

                                      //Strong Password

                                      //

                                      return null;
                                    },
                                  ),
                                ),

                                //
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 8, bottom: 8),
                                  child: TextFormField(
                                    maxLength: 25,
                                    obscureText: _hideConfirmPassword,
                                    controller: _confirmPasswordController,
                                    focusNode: _confirmPasswordFocusNode,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      counterText: '',
                                      labelText:
                                          'Confirm Password\nتصدیقی پاسورڈ',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.indigo.shade500,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(_hideConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _hideConfirmPassword =
                                                !_hideConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter confirm password\n تصدیقی پاسورڈ';
                                      }
                                      if (value.length <= 6) {
                                        return 'Passsword and Confirm Password Must be same\n\nآپ کا پاس ورڈ کم از کم سات حروف کا ہونا ضروری ہے ';
                                      }

                                      if (_passwordController.text != value) {
                                        return 'Passsword and Confirm Password do not match\nپاس ورڈ اور تصدیق پاس ورڈ ایک جیسے ہونا ضروری ہے';
                                      }

                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Gender :',
                                  style: TextStyle(
                                      fontSize: 18,
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
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: Gender.Other,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                              ),
                              Text('Other'),
                            ],
                          ),

                          //
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              padding: EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: 20,
                              ),
                            ),

                            child: _save
                                ? CircularProgressIndicator()
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              final isValid = _fromKey.currentState.validate();
                              if (!isValid) {
                                return null;
                              }

                              await add(
                                SignUpModel(
                                  fullname: _nameController.text.trim(),
                                  phonenumber: _usernameController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  user_type: 'Patient',
                                  gender: _gender == Gender.Male
                                      ? '1'
                                      : _gender == Gender.Female
                                          ? '0'
                                          : '2',
                                ),
                              );

                              Navigator.of(context)
                                  .pushNamed(SignInScreen.routeName);
                            },
                            // color: Theme.of(context).accentColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => SignInScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Text(
                                    'Log in',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'پہلے ہی اکاؤنٹ ہے پھر کلک کریں۔',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
