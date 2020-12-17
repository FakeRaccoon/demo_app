import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationScreenComponent extends StatelessWidget {
  final String title;
  final String content;
  final Timestamp date;
  final colors;

  const NotificationScreenComponent({Key key, this.title, this.content, this.colors, this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.info, size: 15, color: Colors.grey[500]),
                SizedBox(width: 5),
                Text('•', style: TextStyle(color: Colors.grey[500])),
                SizedBox(width: 5),
                Text(DateFormat('d MMM y').format(date.toDate()),
                    style: GoogleFonts.sourceSansPro(fontSize: 14, color: Colors.grey[500])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? 'Ale', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(content ?? 'Ale', style: GoogleFonts.sourceSansPro(color: Colors.grey[500], fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Divider(thickness: 1, height: 0),
          ],
        ),
      ),
    );
  }
}
