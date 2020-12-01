// To parse this JSON data, do
//
//     final reqResPost = reqResPostFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

ReqResPost reqResPostFromJson(String str) =>
    ReqResPost.fromJson(json.decode(str));

String reqResPostToJson(ReqResPost data) => json.encode(data.toJson());

class ReqResPost {
  ReqResPost({
    this.name,
    this.job,
    this.id,
    this.createdAt,
  });

  String name;
  String job;
  String id;
  DateTime createdAt;

  factory ReqResPost.fromJson(Map<String, dynamic> json) => ReqResPost(
        name: json["name"],
        job: json["job"],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "job": job,
        "id": id,
        "createdAt": createdAt.toIso8601String(),
      };

  static Future<ReqResPost> reqResPost() async {
    final http.Response response = await http.post('https://reqres.in/api/users',
        body: jsonEncode({'name': 'Bob', 'job': 'Technician'}));
    if(response.statusCode == 201){
      print(response.body);
      return ReqResPost.fromJson(jsonDecode(response.body));
    }
  }
}
