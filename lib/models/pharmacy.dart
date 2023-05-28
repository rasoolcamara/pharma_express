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
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.description,
    required this.avatar,
    required this.images,
    required this.longitude,
    required this.latitude,
    required this.status,
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
      images: [], // json['images'] as List<String>,
      latitude: num.parse(json['latitude']!),
      longitude: num.parse(json['longitude']!),
    );
  }
}
