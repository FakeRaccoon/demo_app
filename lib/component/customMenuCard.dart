import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomMenuCard extends StatelessWidget {
  final title;
  final ontap;
  final visibility;
  final icon;

  const CustomMenuCard({
    Key key,
    this.title,
    this.ontap,
    this.visibility, this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: InkWell(
        onTap: ontap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: 120,
          height: 120,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.yellow),
                  child: Center(child: FaIcon(icon ?? FontAwesomeIcons.file)),
                ),
              ),
              SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
