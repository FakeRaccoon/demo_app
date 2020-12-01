class UserModel {
  String status;
  String name;
  String age;
  bool admin;
  bool managerial;

  UserModel(this.status);

  Map<String, dynamic> toJson() => {
    'status': status,
    'name': name,
    'age': age,
  };
}