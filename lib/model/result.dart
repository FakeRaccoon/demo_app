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

class AssignedTechnician {
  final int id;
  final int formId;
  final String technicianName;
  final String task;
  final DateTime depart;
  final DateTime technicianReturn;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignedTechnician({
    this.id,
    this.formId,
    this.technicianName,
    this.task,
    this.depart,
    this.technicianReturn,
    this.createdAt,
    this.updatedAt,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return new AssignedTechnician(
      id: json['id'],
      technicianName: json['technicianName'],
      task: json['task'],
    );
  }
}

class TechnicianResult {
  final String technician;
  final int id;
  final int assignmentId;

  TechnicianResult({
    this.assignmentId,
    this.id,
    this.technician,
  });

  factory TechnicianResult.fromJson(Map<String, dynamic> json) {
    return new TechnicianResult(
      id: json['id'],
      assignmentId: json['assignment_id'],
      technician: json['technician'],
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
  final int id;

  EmployeeResult({
    this.id,
    this.name,
  });

  factory EmployeeResult.fromJson(Map<String, dynamic> json) {
    return new EmployeeResult(
      id: json['id'],
      name: json['user_name'],
    );
  }
}
