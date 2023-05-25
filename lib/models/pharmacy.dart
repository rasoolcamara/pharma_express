class Pharmacy {
  int id;
  String name;
  String phone;
  String location;
  String description;
  String status;
  List<String> images;
  String avatar;
  num latitude;
  num longitude;

  Pharmacy({
    this.id,
    this.name,
    this.phone,
    this.location,
    this.description,
    this.avatar,
    this.images,
    this.longitude,
    this.latitude,
    this.status,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      avatar: json['avatar'] as String,
      status: json['status'] as String,
      // images: json['images'] as List<String>,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
    );
  }
}
