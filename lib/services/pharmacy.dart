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
    host: '167.12.1.6',
    port: 3306,
    userName: 'pharma_express_user',
    password: 'qja8bw7p5kwuy5ppmeek',
    maxConnections: 10,
    databaseName: 'pharma_express',
  );
  // mysql+ssh://forge@167.172.143.106/forge@127.0.0.1/forge?name=beautiful-stream&usePrivateKey=true

  Future<List<Pharmacy>> getPharmacies(
    String query, {
    Map<String, dynamic> params,
  }) async {
    var result = await pool.execute(
      query,
      params,
    );
    List<Pharmacy> pharmacys = [];

    for (final row in result.rows) {
      var json = row.assoc();
      print(num.parse(json['id']));
      print(json['name']);
      print(json['phone']);
      print(json['location']);
      print(json['description']);

      pharmacys.add(Pharmacy(
        id: num.parse(json['id']),
        name: json['name'],
        phone: json['phone'],
        location: json['location'],
        description: json['description'],
        avatar: json['avatar'],
        status: json['status'],
        // images: json['images'] as List<String>,
        latitude: json['latitude'] as num,
        longitude: json['longitude'] as num,
      ));
    }
    print("pharmacys.length");
    print(pharmacys.length);
    print(pharmacys.first);

    return pharmacys;
  }
}
