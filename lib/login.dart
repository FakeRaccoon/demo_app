import 'dart:convert';

import 'package:atana/Body.dart';
import 'package:atana/component/button.dart';
import 'package:atana/service/notification.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final _formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscured = true;
    Notif.getOneSignal();
  }

  bool isObscured = true;
  void _toggle() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  var usernameController = TextEditingController();
  var passController = TextEditingController();

  String externalIds;

  @override
  Widget build(BuildContext context) {
    String md5Convert() {
      return md5.convert(utf8.encode(passController.text)).toString();
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(20),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'username tidak boleh kosong';
                        }
                        return null;
                      },
                      controller: usernameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'password tidak boleh kosong';
                        }
                        return null;
                      },
                      obscureText: isObscured,
                      controller: passController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: isObscured == false
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          )),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      title: 'Login',
                      color: Colors.blue,
                      ontap: () {
                        if (_formKey.currentState.validate()) {
                          print(usernameController.text);
                          print(md5Convert());
                          loginTest(usernameController.text, md5Convert());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginTest(String username, String password) async {
    String baseUrl = 'http://192.168.0.7:4948/api/login/signin';

    var response = await http.post(baseUrl, headers: {
      'Accept': 'application/json; charset=utf-8',
      'username': username,
      'password': password
    });
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['token'];
      print(data['tokenKey']);
      print(data['userName']);
      setState(() {
        _username = data['userName'];
        _token = data['tokenKey'];
        setUserInfoPreference().then((value) => Center(child: CircularProgressIndicator())).whenComplete(() {
          setUserInfoPreference();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Body()),
              (Route<dynamic> route) => false);
        });
      });
    } else {
      print('error');
    }
  }

  String _username;
  String _token;

  Future<void> setUserInfoPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('username', _username);
    prefs.setString('token', _token);
    prefs.setString('role', 'Admin');
  }
}
