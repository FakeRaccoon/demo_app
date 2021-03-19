import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/login.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscured = true;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isObscured;
  void _toggle() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  Future register(name, username, password) async {
    try {
      final response = await Dio().post(baseDemoUrl + "register", queryParameters: {
        "name": name,
        "username": username,
        "password": password,
      });
      if (response.statusCode == 200) {
        Flushbar(
          title: "Berhasil",
          message: "Berhasil register",
          duration: Duration(seconds: 3),
        )..show(context).then((value) => Navigator.pop(context));
        NotificationAPI.roleNotification('superuser', 'User baru $name telah melakukan registrasi');
      }
    } on DioError catch (e) {
      if (e.response.data.toString().toLowerCase().contains('duplicate')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Username ini telah digunakan'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.response.statusMessage),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
                    'Register',
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'nama tidak boleh kosong';
                      }
                      return null;
                    },
                    controller: nameController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Nama',
                      prefixIcon: Icon(Icons.person),
                    ),
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
                    controller: passwordController,
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
                          register(
                            nameController.text,
                            usernameController.text,
                            passwordController.text,
                          );
                        }
                      },
                      color: Colors.blue,
                      child: Text('Register',
                          style: GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.bold)),
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
