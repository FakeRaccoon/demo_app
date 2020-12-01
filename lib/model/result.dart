class ProvinceResult {
  final String name;
  final int id;

  ProvinceResult({
    this.id,
    this.name,
  });

  factory ProvinceResult.fromJson(Map<String, dynamic> json) {
    return new ProvinceResult(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CityResult {
  final String name;
  final int id;

  CityResult({
    this.id,
    this.name,
  });

  factory CityResult.fromJson(Map<String, dynamic> json) {
    return new CityResult(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DistrictResult {
  final String name;
  final int id;

  DistrictResult({
    this.id,
    this.name,
  });

  factory DistrictResult.fromJson(Map<String, dynamic> json) {
    return new DistrictResult(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ItemResult {
  final String name;
  final String id;

  ItemResult({
    this.id,
    this.name,
  });

  factory ItemResult.fromJson(Map<String, dynamic> json) {
    return new ItemResult(
      id: json['atanaItemId'],
      name: json['atanaName'],
    );
  }
}