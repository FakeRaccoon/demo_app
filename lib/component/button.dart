import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final ontap;
  final color;

  const CustomButton({Key key, this.title, this.ontap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color),
        height: 40,
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}
