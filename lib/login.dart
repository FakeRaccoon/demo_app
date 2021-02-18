import 'package:atana/Home.dart';
import 'package:atana/body.dart';
import 'package:atana/screen/Register.dart';
import 'package:atana/service/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscured = true;
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    logout();
  }

  SharedPreferences sharedPreferences;

  Future<void> logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();
    print(sharedPreferences.getInt('userId'));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        if (_key.currentState.validate()) {
                          loginTest(usernameController.text, passController.text);
                        }
                      },
                      color: Colors.blue,
                      child: Text(
                        'Login',
                        style: GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    height: 40,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () => Get.to(Register()),
                      color: Colors.transparent,
                      child: Text('Register',
                          style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold)),
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

  Future loginTest(String username, String password) async {
    try {
      final response = await Dio().post(
        baseDemoUrl + "login",
        options: Options(headers: {"Content-Type": "application/json"}),
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
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
      }
    } on DioError catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('login gagal, silahkan cek username dan password anda'),
        backgroundColor: Colors.red,
      ));
    }
  }

  int _id;
  String _username;
  String _token;
  String _role;
  String _name;

  Future setUserInfoPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId', _id);
    prefs.setString('username', _username);
    prefs.setString('name', _name);
    prefs.setString('token', _token);
    prefs.setString('role', _role);
  }
}
