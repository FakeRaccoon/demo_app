class TransportModel {
  final double id;
  final String name;

  TransportModel({this.id, this.name});

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TransportModel(
      id: json["employeeId"],
      name: json["employeeName"],
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