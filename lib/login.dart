import 'dart:convert';

import 'package:atana/body.dart';
import 'package:atana/component/button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

GlobalKey<FormState> _key = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscured = true;
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                            icon: isObscured == false ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                          )),
                    ),
                    SizedBox(height: 20),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          if (_key.currentState.validate()) {
                            // print(usernameController.text);
                            // print(md5Convert());
                            // loginTest(usernameController.text, md5Convert());
                            loginTest(usernameController.text, passController.text);
                            setUserInfoPreference().whenComplete(() {
                              // Notif.getOneSignal();
                            });
                          }
                        },
                        color: Colors.blue,
                        child: Text('Login', style: GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    )
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
    String localUrl = 'http://10.0.2.2:8000/api/login';

    // var response = await http.post(baseUrl, body: {
    //   'Accept': 'application/json; charset=utf-8',
    //   'username': username,
    //   'password': password
    // });
    var response = await http.post(localUrl, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'];
      // print(data['token']);
      // print(data['username']);
      setState(() {
        _id = data['id'];
        _username = data['username'];
        _token = data['token'];
        _role = data['role'];
        _name = data['name'];
        setUserInfoPreference().then((value) => Center(child: CircularProgressIndicator())).whenComplete(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Body()), (Route<dynamic> route) => false);
        });
      });
    } else {
      print('error');
    }
  }

  int _id;
  String _username;
  String _token;
  String _role;
  String _name;

  Future<void> setUserInfoPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId', _id);
    prefs.setString('username', _username);
    prefs.setString('name', _name);
    prefs.setString('token', _token);
    prefs.setString('role', _role);
  }
}
