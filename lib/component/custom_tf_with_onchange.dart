import 'package:flutter/material.dart';

class CustomTextFieldOnChanged extends StatelessWidget {

  final ontap;
  final controller;
  final onChanged;
  final bool readOnly;
  final Icon icon;
  final String hintText;

  const CustomTextFieldOnChanged({Key key, this.controller, this.icon, this.hintText, this.ontap, this.readOnly, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(231, 235, 237, 100)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            readOnly: readOnly,
            onTap: ontap,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: icon,
            ),
          ),
        ),
      ),
    );
  }
}
