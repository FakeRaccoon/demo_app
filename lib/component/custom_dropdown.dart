import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {


  final dropvalue;
  final listvalue;
  final onchange;

  const CustomDropdown({Key key, this.dropvalue, this.listvalue, this.onchange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(231, 235, 237, 100),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: DropdownButton(
              hint: Text("Pilih Kota"),
              value: dropvalue,
              items: listvalue.map((value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: onchange,
            ),
          ),
        ),
      ),
    );
  }
}
