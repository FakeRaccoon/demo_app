import 'dart:convert';
import 'dart:io';

import 'package:atana/Body.dart';
import 'package:atana/component/button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscured = true;
    getOneSignal();
  }

  bool isObscured = true;
  void _toggle() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String externalIds;

  @override
  Widget build(BuildContext context) {
    String md5Convert() {
      return md5.convert(utf8.encode(passController.text)).toString();
    }

    return Scaffold(
      body: SafeArea(
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
                    controller: usernameController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
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
                      print(usernameController.text);
                      print(md5Convert());
                      // loginTest(usernameController.text, md5Convert());
                      sendAndGetNotification();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  var notificationUrl = "https://onesignal.com/api/v1/notifications";
  var notificationKey = "YjY1MmY2NTUtY2YwNC00OGRlLThkNTgtZmVkNGE0ODA0NmUz";
  var customExternalUserId = "teknisi123";

  Future getOneSignal() async {
    var userId = await OneSignal.shared.setExternalUserId(customExternalUserId);
    print(userId);
  }

  Future sendAndGetNotification() async {
    var dataMap = {"foo": "bar"};
    String data = jsonEncode(dataMap);

    var contentMap = {"en": "this is new notification"};
    String content = jsonEncode(contentMap);
    String appId = "956ae786-10ab-4d63-a9dd-82fb34904881";

    final List userIdsList = ["teknisi123"];
    final decoded = jsonEncode(userIdsList);
    final response = await http.post(notificationUrl,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": "BASIC " + notificationKey,
        },
        body: jsonEncode({
          "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
          "include_external_user_ids": userIdsList,
          "channel_for_external_user_ids": "push",
          "data": {"foo": "bar"},
          "headings": {"en": "Halo!"},
          "contents": {"en": "Ada notifikasi baru nih"}
        }));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
      print(externalIds);
    }
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
        setUserInfoPreference().whenComplete(() {
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
  }
}
