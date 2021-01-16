// To parse this JSON data, do
//
//     final formResult = formResultFromJson(jsonString);

import 'dart:convert';

List<FormResult> formResultFromJson(String str) => List<FormResult>.from(json.decode(str).map((x) => FormResult.fromJson(x)));

String formResultToJson(List<FormResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormResult {
  FormResult({
    this.id,
    this.province,
    this.city,
    this.district,
    this.user,
    this.item,
    this.fee,
    this.transport,
    this.driver,
    this.technician,
    this.estimatedDate,
    this.type,
    this.status,
    this.image,
    this.departureDate,
    this.returnDate,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String province;
  String city;
  String district;
  User user;
  Item item;
  List<Fee> fee;
  Transport transport;
  Driver driver;
  List<Technician> technician;
  DateTime estimatedDate;
  String type;
  String status;
  String image;
  DateTime departureDate;
  DateTime returnDate;
  DateTime createdAt;
  DateTime updatedAt;

  factory FormResult.fromJson(Map<String, dynamic> json) => FormResult(
    id: json["id"] == null ? null : json["id"],
    province: json["province"] == null ? null : json["province"],
    city: json["city"] == null ? null : json["city"],
    district: json["district"] == null ? null : json["district"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    fee: json["fee"] == null ? null : List<Fee>.from(json["fee"].map((x) => Fee.fromJson(x))),
    transport: json["transport"] == null ? null : Transport.fromJson(json["transport"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    technician: json["technician"] == null ? null : List<Technician>.from(json["technician"].map((x) => Technician.fromJson(x))),
    estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
    type: json["type"] == null ? null : json["type"],
    status: json["status"] == null ? null : json["status"],
    image: json["image"] == null ? null : json["image"],
    departureDate: json["departure_date"] == null ? null : DateTime.parse(json["departure_date"]),
    returnDate: json["return_date"] == null ? null : DateTime.parse(json["return_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "province": province == null ? null : province,
    "city": city == null ? null : city,
    "district": district == null ? null : district,
    "user": user == null ? null : user.toJson(),
    "item": item == null ? null : item.toJson(),
    "fee": fee == null ? null : List<dynamic>.from(fee.map((x) => x.toJson())),
    "transport": transport == null ? null : transport.toJson(),
    "driver": driver == null ? null : driver.toJson(),
    "technician": technician == null ? null : List<dynamic>.from(technician.map((x) => x.toJson())),
    "estimated_date": estimatedDate == null ? null : estimatedDate.toIso8601String(),
    "type": type == null ? null : type,
    "status": status == null ? null : status,
    "image": image == null ? null : image,
    "departure_date": departureDate == null ? null : departureDate.toIso8601String(),
    "return_date": returnDate == null ? null : returnDate.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Driver {
  Driver({
    this.id,
    this.formId,
    this.userId,
    this.name,
    this.transport,
    this.transportId,
  });

  int id;
  int formId;
  int userId;
  String name;
  String transport;
  int transportId;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    name: json["name"] == null ? null : json["name"],
    transport: json["transport"] == null ? null : json["transport"],
    transportId: json["transport_id"] == null ? null : json["transport_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "user_id": userId == null ? null : userId,
    "name": name == null ? null : name,
    "transport": transport == null ? null : transport,
    "transport_id": transportId == null ? null : transportId,
  };
}

class Fee {
  Fee({
    this.id,
    this.formId,
    this.fee,
    this.description,
  });

  int id;
  int formId;
  int fee;
  String description;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    fee: json["fee"] == null ? null : json["fee"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "fee": fee == null ? null : fee,
    "description": description == null ? null : description,
  };
}

class Item {
  Item({
    this.id,
    this.atanaItemId,
    this.atanaName,
    this.atanaAlias,
  });

  int id;
  int atanaItemId;
  String atanaName;
  String atanaAlias;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    atanaItemId: json["atanaItemId"] == null ? null : json["atanaItemId"],
    atanaName: json["atanaName"] == null ? null : json["atanaName"],
    atanaAlias: json["atanaAlias"] == null ? null : json["atanaAlias"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "atanaItemId": atanaItemId == null ? null : atanaItemId,
    "atanaName": atanaName == null ? null : atanaName,
    "atanaAlias": atanaAlias == null ? null : atanaAlias,
  };
}

class Technician {
  Technician({
    this.id,
    this.formId,
    this.name,
    this.task,
    this.depart,
    this.technicianReturn,
  });

  int id;
  int formId;
  String name;
  dynamic task;
  dynamic depart;
  dynamic technicianReturn;

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    name: json["name"] == null ? null : json["name"],
    task: json["task"],
    depart: json["depart"],
    technicianReturn: json["return"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "name": name == null ? null : name,
    "task": task,
    "depart": depart,
    "return": technicianReturn,
  };
}

class Transport {
  Transport({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.username,
    this.role,
    this.selected,
  });

  int id;
  String name;
  String username;
  String role;
  bool selected;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    role: json["role"] == null ? null : json["role"],
    selected: json["selected"] == null ? null : json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "role": role == null ? null : role,
    "selected": selected == null ? null : selected,
  };
}
