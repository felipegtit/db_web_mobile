class TableDataModel {
  int? id;
  String? name;

  TableDataModel({
    this.id,
    this.name
  });

  TableDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}