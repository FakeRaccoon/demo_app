class TransportModel {
  final int id;
  final String name;
  final String type;
  final String plate;

  TransportModel({this.id, this.name, this.type, this.plate});

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TransportModel(
      id: json["id"],
      name: json["name"],
      type: json['type'],
      plate: json['plate'],
    );
  }

  static List<TransportModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => TransportModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByProvinceId(String filter) {
    return this?.id?.toString()?.contains(filter);
  }

  @override
  String toString() => name;
}