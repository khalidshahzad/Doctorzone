import '/exception.dart';
import 'package:toast/toast.dart';

import '../services/login_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import '../model/login_model.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = 'Login_screen';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isloading = true;
  // bool _submit = false;
  bool verifypassword(
    String password,
    String hash,
  ) {
    return Password.verify(
      password,
      hash,
    );
  }

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  String userinfo = '';
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  FocusNode _confirmPasswordFocusNode;

  SharedPreferences _logindata;
  bool newuser = true;

  @override
  void initState() {
    try {
      Future.delayed(Duration(seconds: 3));
      check_if_already_login();
      setState(() {
        _isloading = false;
      });
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  void check_if_already_login() async {
    try {
      // Future.delayed(Duration(seconds: 3));
      _logindata = await SharedPreferences.getInstance();
      newuser = (_logindata.getBool('login') ?? true);
      print(newuser);
      if (newuser == false) {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => ServicesScreen()));
      }
    } catch (e) {
      ShowExceptionDialogBox.showExceptionDialog(context);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                  width: double.infinity,
                  height: 230,
                  color: Colors.indigo.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 80),
                          child: Text(
                            'DoctorZone.pk',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Container(
                                color: Colors.white,
                                height: 40,
                                width: 40,
                                child: Image.asset(
                                  'asset/logo/DoctorZone.png',
                                  //color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 145),
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10, top: 10),
                              child: TextFormField(
                                maxLength: 11,
                                controller: _username,
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(),
                                  labelText: 'Username/فون نمبر یا نام',
                                  hintText: ' 0302 xxxx234',
                                  labelStyle: TextStyle(),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.indigo.shade900,
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter username/براہ کرم اپنا نام یا فون نمبر درج کریں';
                                  }
                                  if (value.length <= 2) {
                                    return 'Please enter valid username \n براہ کرم اپنا نام یا فون نمبر درج کریں';
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
                                  top: 10, left: 20, right: 20, bottom: 10),
                              child: TextFormField(
                                maxLength: 25,
                                obscureText: _hidePassword,
                                controller: _password,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password/پاسورڈ',
                                  labelStyle: TextStyle(),
                                  counterText: '',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.indigo.shade900,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _hidePassword = !_hidePassword;
                                      });
                                    },
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_confirmPasswordFocusNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter password/براہ کرم پاسورڈدرج کریں';
                                  }

                                  if (value.length <= 6) {
                                    return 'آپ کو چھ حرف سے زیادہ پاس ورڈ داخل کرنا چاہئے';
                                  }

                                  //Strong Password

                                  //

                                  return null;
                                },
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 14),
                              ),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  userinfo = '';
                                });
                                final isValid =
                                    _formKey.currentState.validate();
                                if (!isValid) {
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text('Please Wait'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                //  Navigator.of(context).pop();

                                List<SignInModel> users =
                                    await SigninServices().getUsers();
                                SignInModel user = users.firstWhere(
                                    (comingUser) =>
                                        comingUser.user_name == _username.text,
                                    orElse: () => SignInModel());
                                print('Coming From DB : ${user.id}');
                                if (user.user_name != null) {
                                  // if (verifypassword(
                                  //     _password.text, user.hash))

                                  if (_password.text == user.password) {
                                    _logindata.setString(
                                        'user_name', user.user_name);
                                    _logindata.setString(
                                        'user_type', user.user_type);
                                    _logindata.setString('id', user.id);
                                    print('Login Time UserID : ${user.id}');
                                    _logindata.setBool('login', false);
                                    //_logindata.setString('id', user.id);
                                    Toast.show(
                                        "You have login sucessfully\nآپ نے کامیابی کے ساتھ لاگ ان کیا ہے۔",
                                        context,
                                        gravity: Toast.CENTER,
                                        duration: 2);
                                    Navigator.of(context).pushReplacementNamed(
                                        (ServicesScreen.routeName));
                                  } else {
                                    setState(() {
                                      userinfo =
                                          'Incorrect Password\nآپ کاپاسورڈغلط ہے';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    userinfo =
                                        'Account not found please sign up\nاکاؤنٹ نہیں ملا برائے مہربانی سائن اپ کریں۔';
                                  });
                                }
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: InkWell(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  SignupScreen.routeName);
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      ' نیا صارف برائے مہربانی سائن اپ پر کلک کریں۔',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                userinfo,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
