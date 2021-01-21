import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final ontap;
  final color;

  const CustomOutlineButton({Key key, this.title, this.ontap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      minWidth: MediaQuery.of(context).size.width,
      height: 40,
      child: OutlineButton(
        borderSide: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: ontap,
        child: Text(
          title,
          style: GoogleFonts.openSans(color: color, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
