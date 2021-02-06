// To parse this JSON data, do
//
//     final formResult = formResultFromJson(jsonString);

import 'dart:convert';

List<FormResult> formResultFromJson(String str) =>
    List<FormResult>.from(json.decode(str).map((x) => FormResult.fromJson(x)));

String formResultToJson(List<FormResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormResult {
  FormResult({
    this.id,
    this.province,
    this.city,
    this.district,
    this.user,
    this.itemId,
    this.item,
    this.warehouse,
    this.fee,
    this.transport,
    this.driver,
    this.technician,
    this.estimatedDate,
    this.type,
    this.status,
    this.rejectReason,
    this.image,
    this.departureDate,
    this.returnDate,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  Province province;
  City city;
  District district;
  User user;
  String itemId;
  String item;
  String warehouse;
  List<Fee> fee;
  Transport transport;
  dynamic driver;
  List<dynamic> technician;
  DateTime estimatedDate;
  String type;
  String status;
  String rejectReason;
  dynamic image;
  DateTime departureDate;
  DateTime returnDate;
  DateTime createdAt;
  DateTime updatedAt;

  factory FormResult.fromJson(Map<String, dynamic> json) => FormResult(
        id: json["id"] == null ? null : json["id"],
        province: json["province"] == null ? null : Province.fromJson(json["province"]),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        district: json["district"] == null ? null : District.fromJson(json["district"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        itemId: json["item_id"] == null ? null : json["item_id"],
        item: json["item"] == null ? null : json["item"],
        warehouse: json["warehouse"] == null ? null : json["warehouse"],
        fee: json["fee"] == null ? null : List<Fee>.from(json["fee"].map((x) => Fee.fromJson(x))),
        transport: json["transport"] == null ? null : Transport.fromJson(json["transport"]),
        driver: json["driver"],
        technician: json["technician"] == null
            ? null
            : List<Technician>.from(json["technician"].map((x) => Technician.fromJson(x))),
        estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
        type: json["type"] == null ? null : json["type"],
        status: json["status"] == null ? null : json["status"],
        rejectReason: json["reject_reason"] == null ? null : json["reject_reason"],
        image: json["image"] == null ? null : json["image"],
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
        "item_id": itemId == null ? null : itemId,
        "item": item == null ? null : item,
        "warehouse": warehouse == null ? null : warehouse,
        "fee": fee == null ? null : List<dynamic>.from(fee.map((x) => x.toJson())),
        "transport": transport == null ? null : transport.toJson(),
        "driver": driver,
        "technician": technician == null ? null : List<dynamic>.from(technician.map((x) => x)),
        "estimated_date": estimatedDate == null ? null : estimatedDate.toIso8601String(),
        "type": type == null ? null : type,
        "status": status == null ? null : status,
        "reject_reason": rejectReason == null ? null : rejectReason,
        "image": image == null ? null : image,
        "departure_date": departureDate == null ? null : departureDate.toIso8601String(),
        "return_date": returnDate == null ? null : returnDate.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Province {
  Province({
    this.id,
    this.provinceId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int provinceId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json["id"] == null ? null : json["id"],
        provinceId: json["province_id"] == null ? null : int.parse(json["province_id"]),
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "province_id": provinceId == null ? null : provinceId,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class City {
  City({
    this.id,
    this.cityId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int cityId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"] == null ? null : json["id"],
        cityId: json["province_id"] == null ? null : int.parse(json["province_id"]),
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "cityId": cityId == null ? null : cityId,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class District {
  District({
    this.id,
    this.districtId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int districtId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"] == null ? null : json["id"],
        districtId: json["district_id"] == null ? null : int.parse(json["district_id"]),
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "districtId": districtId == null ? null : districtId,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Transport {
  Transport({
    this.id,
    this.name,
    this.platNo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  String name;
  String platNo;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        platNo: json["plat_no"] == null ? null : json["plat_no"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "platNo": platNo == null ? null : platNo,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
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
  String formId;
  int fee;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        id: json["id"] == null ? null : json["id"],
        formId: json["form_id"] == null ? null : json["form_id"],
        fee: json["fee"] == null ? null : int.parse(json["fee"]),
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

class Technician {
  Technician({
    this.id,
    this.formId,
    this.name,
    this.task,
    this.warehouse,
    this.depart,
    this.technicianReturn,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String formId;
  String name;
  String task;
  String warehouse;
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
        warehouse: json["warehouse"] == null ? null : json["warehouse"],
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
        "warehouse": warehouse == null ? null : warehouse,
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
