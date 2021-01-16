import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
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
  final bool autofocus;
  final labelText;
  final validator;

  const CustomTextField(
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
      this.customHeight,
      this.autofocus, this.labelText, this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10),
      child: Center(
        child: TextFormField(
          validator: validator,
          inputFormatters: inputformat,
          controller: controller,
          readOnly: readOnly ?? false,
          onTap: ontap,
          onChanged: onchange,
          keyboardType: keyboardtype,
          decoration: InputDecoration(
            labelText: labelText,
            alignLabelWithHint: true,
            prefixIcon: prefixIcon,
            prefix: prefix,
            hintText: hintText,
            suffixIcon: icon,
          ),
        ),
      ),
    );
  }
}
