import 'package:flutter/material.dart';

import 'mainscreen.dart';
import 'registrationscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(30, 60, 30, 0),
                  child: Image.asset('assets/images/logo4.png', scale: 1.3)),
              SizedBox(height: 1),
              Card(
                
                shadowColor: Colors.red.shade900,
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
                  child: Column(
                    children: [
                      
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email,color: Colors.red.shade900)),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password', icon: Icon(Icons.lock,color: Colors.red.shade900)),
                        obscureText: true,
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Colors.red.shade900,
                              value: _rememberMe,
                              onChanged: (bool value) {
                                _onchange(value);
                              }),
                          Text('Remember Me')
                        ],
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minWidth: 150,
                        height: 40,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _onLogin,
                        color: Colors.red[900],
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Text(
                  'Sign Up New Account Now!',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: _registerNewUser,
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: _forgotPassword,
              )
            ],
          ),
        )),
      ),
    );
  }

  void _onLogin() {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Login Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Forgot Your Password?'),
            content: new Container(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Text('Enter your recovery email'),
                TextField(
                  controller: _useremailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email', icon: Icon(Icons.email,color: Colors.red.shade900)),
                )
              ],
            ))),
            actions: [
              TextButton(
                child: Text('Submit', style: TextStyle(color: Colors.red.shade900),),
                onPressed: () {
                  _resetPass(_useremailController.text);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.red.shade900)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _onchange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Email and Password..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      _rememberMe = value;
      storePref(value, _email, _password);
    });
  }

  Future<void> storePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('rememberme', value);
      Fluttertoast.showToast(
          msg: "You're Remembered! =D",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', value);
      Fluttertoast.showToast(
          msg: "You've been removed! =(",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("rememberme") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  void _resetPass(String resetemail) {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/reset_user.php"),
        body: {"email": resetemail}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Please check your email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
        
      } else {
        Fluttertoast.showToast(
            msg: "Password Reset Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
