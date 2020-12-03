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
  final double id;

  ItemResult({
    this.id,
    this.name,
  });

  factory ItemResult.fromJson(Map<String, dynamic> json) {
    return new ItemResult(
      id: json['itemId'],
      name: json['itemName'],
    );
  }
}

class AccountKasResult {
  final String name;
  final double id;

  AccountKasResult({
    this.id,
    this.name,
  });

  factory AccountKasResult.fromJson(Map<String, dynamic> json) {
    return new AccountKasResult(
      id: json['coaId'],
      name: json['coaName'],
    );
  }
}

class AccountFeeResult {
  final String name;
  final double id;

  AccountFeeResult({
    this.id,
    this.name,
  });

  factory AccountFeeResult.fromJson(Map<String, dynamic> json) {
    return new AccountFeeResult(
      id: json['coaId'],
      name: json['coaName'],
    );
  }
}

class WarehouseResult {
  final String name;
  final double id;

  WarehouseResult({
    this.id,
    this.name,
  });

  factory WarehouseResult.fromJson(Map<String, dynamic> json) {
    return new WarehouseResult(
      id: json['warehouseId'],
      name: json['warehouseName'],
    );
  }
}

class EmployeeResult {
  final String name;
  final double id;

  EmployeeResult({
    this.id,
    this.name,
  });

  factory EmployeeResult.fromJson(Map<String, dynamic> json) {
    return new EmployeeResult(
      id: json['employeeId'],
      name: json['employeeName'],
    );
  }
}