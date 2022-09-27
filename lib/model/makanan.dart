class Makanan {
  int? id;
  String? name;
  String? category;

  Makanan({this.id, this.name, this.category});

  factory Makanan.fromMap(Map<String, dynamic> map) {
    return Makanan(
      id: map['id'],
      name: map['name'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'name': name,
      'category': category
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}