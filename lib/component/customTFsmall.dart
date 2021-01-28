import 'package:flutter/material.dart';

class CustomTextFieldSmall extends StatelessWidget {
  final ontap;
  final onchange;
  final controller;
  final keyboardtype;
  final inputformat;
  final prefix;
  final prefixIcon;
  final bool readOnly;
  final Icon icon;
  final String hintText;
  final double customHeight;

  const CustomTextFieldSmall(
      {Key key,
        this.controller,
        this.icon,
        this.hintText,
        this.ontap,
        this.readOnly,
        this.onchange,
        this.keyboardtype,
        this.inputformat,
        this.prefix,
        this.prefixIcon,
        this.customHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(231, 235, 237, 100)),
      child: Center(
        child: TextFormField(
          autofocus: true,
          inputFormatters: inputformat,
          controller: controller,
          readOnly: readOnly ?? false,
          onTap: ontap,
          onChanged: onchange,
          keyboardType: keyboardtype,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            prefixIcon: prefixIcon,
            prefix: prefix,
            hintText: hintText,
            border: InputBorder.none,
            suffixIcon: icon,
          ),
        ),
      ),
    );
  }
}
