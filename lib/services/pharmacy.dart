import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'package:pharma_express/models/pharmacy.dart';
import 'package:pharma_express/properties/app_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

class PharmacyService {
  final pool = MySQLConnectionPool(
    host: '167.172.143.106',
    port: 3306,
    userName: 'pharma_express_user',
    password: 'qja8bw7p5kwuy5ppmeek',
    maxConnections: 10,
    databaseName: 'pharma_express',
  );
  // mysql+ssh://forge@167.172.143.106/forge@127.0.0.1/forge?name=beautiful-stream&usePrivateKey=true

  Future<List<Pharmacy>> getPharmacies(
    String query, {
    Map<String, dynamic>? params,
  }) async {
    var result = await pool.execute(
      query,
      params,
    );
    List<Pharmacy> pharmacys = [];

    for (final row in result.rows) {
      var json = row.assoc();

      print(json['name']);
      print(json['phone']);
      print(json['location']);
      print(json['description']);

      pharmacys.add(Pharmacy(
        id: int.parse(json['id']!),
        name: json['name'] as String,
        phone: json['phone'] as String,
        location: json['location'] as String,
        description: json['description'] as String,
        avatar: json['avatar'] as String,
        status: json['status'] as String,
        images: [], // json['images'] as List<String>,
        latitude: num.parse(json['latitude']!),
        longitude: num.parse(json['longitude']!),
      ));
    }
    print("pharmacys.length");
    print(pharmacys.length);
    print(pharmacys.first);

    return pharmacys;
  }
}
