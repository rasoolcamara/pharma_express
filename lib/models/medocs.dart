class Medoc {
  int id;
  String name;
  String number;
  String description;
  String avatar;


  Medoc({
    this.id,
    this.name,
    this.number,
    this.description,
    this.avatar,
  });

  factory Medoc.fromJson(Map<String, dynamic> json) {
    return Medoc(
      id: json['id'] as int,
      name: json['name'] as String,
      number: json['serie_number'] as String,
      description: json['description'] as String,
      avatar: json['avatar'] as String,
    );
  }
}
