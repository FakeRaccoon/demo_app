import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDenseButton extends StatelessWidget {
  final String title;
  final onTap;
  final color;

  const CustomDenseButton({Key key, this.title, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      minWidth: MediaQuery.of(context).size.width,
      height: 40,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color,
        onPressed: onTap,
        child: Text(
          title,
          style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
