import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMenuCard extends StatelessWidget {
  final title;
  final ontap;
  final visibility;
  final icon;
  final textColor;
  final color;

  const CustomMenuCard({
    Key key,
    this.title,
    this.ontap,
    this.visibility, this.icon, this.textColor, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: 120,
      height: 120,
      child: Column(
        children: [
          InkWell(
            onTap: ontap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: color),
                child: Center(child: FaIcon(icon ?? FontAwesomeIcons.file, color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(title, style: GoogleFonts.openSans(color: textColor), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
