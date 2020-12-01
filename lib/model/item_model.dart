class Item {
  String id;
  String name;

  Item(String id, String name) {
    this.id = id;
    this.name = name;
  }

  Item.fromJson(Map json)
      : id = json['atanaItemId'],
        name = json['atanaName'];

  Map toJson() {
    return {'atanaItemId': id, 'atanaName': name};
  }
}