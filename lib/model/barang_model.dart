class BarangModel {
  final String id;
  final String name;

  BarangModel({this.id, this.name});

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return BarangModel(
      id: json["atanaItemId"],
      name: json["atanaName"],
    );
  }

  static List<BarangModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => BarangModel.fromJson(item)).toList();
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