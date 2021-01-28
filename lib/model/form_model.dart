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
  City province;
  City city;
  City district;
  User user;
  Item item;
  List<Fee> fee;
  City transport;
  Driver driver;
  List<Technician> technician;
  DateTime estimatedDate;
  String type;
  String status;
  dynamic image;
  DateTime departureDate;
  DateTime returnDate;
  DateTime createdAt;
  DateTime updatedAt;

  factory FormResult.fromJson(Map<String, dynamic> json) => FormResult(
    id: json["id"] == null ? null : json["id"],
    province: json["province"] == null ? null : City.fromJson(json["province"]),
    city: json["city"] == null ? null : City.fromJson(json["city"]),
    district: json["district"] == null ? null : City.fromJson(json["district"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    fee: json["fee"] == null ? null : List<Fee>.from(json["fee"].map((x) => Fee.fromJson(x))),
    transport: json["transport"] == null ? null : City.fromJson(json["transport"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    technician: json["technician"] == null ? null : List<Technician>.from(json["technician"].map((x) => Technician.fromJson(x))),
    estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
    type: json["type"] == null ? null : json["type"],
    status: json["status"] == null ? null : json["status"],
    image: json["image"],
    departureDate: json["departure_date"] == null ? null : DateTime.parse(json["departure_date"]),
    returnDate: json["return_date"] == null ? null : DateTime.parse(json["return_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "province": province == null ? null : province.toJson(),
    "city": city == null ? null : city.toJson(),
    "district": district == null ? null : district.toJson(),
    "user": user == null ? null : user.toJson(),
    "item": item == null ? null : item.toJson(),
    "fee": fee == null ? null : List<dynamic>.from(fee.map((x) => x.toJson())),
    "transport": transport == null ? null : transport.toJson(),
    "driver": driver == null ? null : driver.toJson(),
    "technician": technician == null ? null : List<dynamic>.from(technician.map((x) => x.toJson())),
    "estimated_date": estimatedDate == null ? null : estimatedDate.toIso8601String(),
    "type": type == null ? null : type,
    "status": status == null ? null : status,
    "image": image,
    "departure_date": departureDate == null ? null : departureDate.toIso8601String(),
    "return_date": returnDate == null ? null : returnDate.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class City {
  City({
    this.id,
    this.provinceId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.cityId,
    this.platNo,
  });

  int id;
  int provinceId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int cityId;
  dynamic platNo;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"] == null ? null : json["id"],
    provinceId: json["province_id"] == null ? null : json["province_id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    cityId: json["city_id"] == null ? null : json["city_id"],
    platNo: json["plat_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "province_id": provinceId == null ? null : provinceId,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "city_id": cityId == null ? null : cityId,
    "plat_no": platNo,
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
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  int userId;
  String name;
  String transport;
  int transportId;
  dynamic createdAt;
  dynamic updatedAt;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    name: json["name"] == null ? null : json["name"],
    transport: json["transport"] == null ? null : json["transport"],
    transportId: json["transport_id"] == null ? null : json["transport_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "user_id": userId == null ? null : userId,
    "name": name == null ? null : name,
    "transport": transport == null ? null : transport,
    "transport_id": transportId == null ? null : transportId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Fee {
  Fee({
    this.id,
    this.formId,
    this.fee,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  int fee;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    fee: json["fee"] == null ? null : json["fee"],
    description: json["description"] == null ? null : json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "fee": fee == null ? null : fee,
    "description": description == null ? null : description,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Item {
  Item({
    this.id,
    this.atanaItemId,
    this.atanaName,
    this.atanaAlias,
    this.atanaWeight,
    this.atanaPrice,
    this.atanaStock,
    this.atanaCurrencyId,
    this.atanaCurrencyName,
    this.atanaKurs,
    this.atanaDate,
    this.atanaUpdate,
  });

  int id;
  int atanaItemId;
  String atanaName;
  String atanaAlias;
  dynamic atanaWeight;
  dynamic atanaPrice;
  dynamic atanaStock;
  dynamic atanaCurrencyId;
  dynamic atanaCurrencyName;
  dynamic atanaKurs;
  DateTime atanaDate;
  DateTime atanaUpdate;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    atanaItemId: json["atanaItemId"] == null ? null : json["atanaItemId"],
    atanaName: json["atanaName"] == null ? null : json["atanaName"],
    atanaAlias: json["atanaAlias"] == null ? null : json["atanaAlias"],
    atanaWeight: json["atanaWeight"] == null ? null : json["atanaWeight"],
    atanaPrice: json["atanaPrice"] == null ? null : json["atanaPrice"],
    atanaStock: json["atanaStock"] == null ? null : json["atanaStock"],
    atanaCurrencyId: json["atanaCurrencyId"] == null ? null : json["atanaCurrencyId"],
    atanaCurrencyName: json["atanaCurrencyName"] == null ? null : json["atanaCurrencyName"],
    atanaKurs: json["atanaKurs"] == null ? null : json["atanaKurs"],
    atanaDate: json["atanaDate"] == null ? null : DateTime.parse(json["atanaDate"]),
    atanaUpdate: json["atanaUpdate"] == null ? null : DateTime.parse(json["atanaUpdate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "atanaItemId": atanaItemId == null ? null : atanaItemId,
    "atanaName": atanaName == null ? null : atanaName,
    "atanaAlias": atanaAlias == null ? null : atanaAlias,
    "atanaWeight": atanaWeight == null ? null : atanaWeight,
    "atanaPrice": atanaPrice == null ? null : atanaPrice,
    "atanaStock": atanaStock == null ? null : atanaStock,
    "atanaCurrencyId": atanaCurrencyId == null ? null : atanaCurrencyId,
    "atanaCurrencyName": atanaCurrencyName == null ? null : atanaCurrencyName,
    "atanaKurs": atanaKurs == null ? null : atanaKurs,
    "atanaDate": atanaDate == null ? null : atanaDate.toIso8601String(),
    "atanaUpdate": atanaUpdate == null ? null : atanaUpdate.toIso8601String(),
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
    this.confirmed,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  String name;
  String task;
  DateTime depart;
  DateTime technicianReturn;
  bool confirmed;
  DateTime createdAt;
  DateTime updatedAt;

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    name: json["name"] == null ? null : json["name"],
    task: json["task"] == null ? null : json["task"],
    depart: json["depart"] == null ? null : DateTime.parse(json["depart"]),
    technicianReturn: json["return"] == null ? null : DateTime.parse(json["return"]),
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "name": name == null ? null : name,
    "task": task == null ? null : task,
    "depart": depart == null ? null : depart.toIso8601String(),
    "return": technicianReturn == null ? null : technicianReturn.toIso8601String(),
    "confirmed": confirmed == null ? null : confirmed,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class User {
  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
