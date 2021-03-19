// To parse this JSON data, do
//
//     final transportDetail = transportDetailFromJson(jsonString);

import 'dart:convert';

List<TransportDetail> transportDetailFromJson(String str) => List<TransportDetail>.from(json.decode(str).map((x) => TransportDetail.fromJson(x)));

String transportDetailToJson(List<TransportDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransportDetail {
  TransportDetail({
    this.id,
    this.name,
    this.plat,
    this.kilometer,
    this.image,
    this.idle,
    this.rentalDate,
    this.returnDate,
    this.history,
  });

  int id;
  String name;
  String plat;
  int kilometer;
  String image;
  bool idle;
  DateTime rentalDate;
  DateTime returnDate;
  List<History> history;

  factory TransportDetail.fromJson(Map<String, dynamic> json) => TransportDetail(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    plat: json["plat"] == null ? null : json["plat"],
    kilometer: json["kilometer"] == null ? null : json["kilometer"],
    image: json["image"] == null ? null : json["image"],
    idle: json["idle"] == null ? null : json["idle"],
    rentalDate: json["rental_date"] == null ? null : DateTime.parse(json["rental_date"]),
    returnDate: json["return_date"] == null ? null : DateTime.parse(json["return_date"]),
    history: json["history"] == null ? null : List<History>.from(json["history"].map((x) => History.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "plat": plat == null ? null : plat,
    "kilometer": kilometer == null ? null : kilometer,
    "image": image == null ? null : image,
    "idle": idle == null ? null : idle,
    "rental_date": rentalDate == null ? null : rentalDate.toIso8601String(),
    "return_date": returnDate == null ? null : returnDate.toIso8601String(),
    "history": history == null ? null : List<dynamic>.from(history.map((x) => x.toJson())),
  };
}

class History {
  History({
    this.id,
    this.transportId,
    this.driverId,
    this.description,
    this.rentDate,
    this.returnDate,
    this.createdAt,
    this.updatedAt,
    this.driver,
  });

  int id;
  int transportId;
  int driverId;
  String description;
  DateTime rentDate;
  DateTime returnDate;
  DateTime createdAt;
  DateTime updatedAt;
  Driver driver;

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"] == null ? null : json["id"],
    transportId: json["transport_id"] == null ? null : json["transport_id"],
    driverId: json["driver_id"] == null ? null : json["driver_id"],
    description: json["description"] == null ? null : json["description"],
    rentDate: json["rent_date"] == null ? null : DateTime.parse(json["rent_date"]),
    returnDate: json["return_date"] == null ? null : DateTime.parse(json["return_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "transport_id": transportId == null ? null : transportId,
    "driver_id": driverId == null ? null : driverId,
    "description": description == null ? null : description,
    "rent_date": rentDate == null ? null : rentDate.toIso8601String(),
    "return_date": returnDate == null ? null : returnDate.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "driver": driver == null ? null : driver.toJson(),
  };
}

class Driver {
  Driver({
    this.id,
    this.name,
    this.username,
    this.role,
    this.selected,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String username;
  String role;
  bool selected;
  DateTime createdAt;
  DateTime updatedAt;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    role: json["role"] == null ? null : json["role"],
    selected: json["selected"] == null ? null : json["selected"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "role": role == null ? null : role,
    "selected": selected == null ? null : selected,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
