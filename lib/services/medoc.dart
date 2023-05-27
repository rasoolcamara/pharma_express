import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'package:pharma_express/models/medocs.dart';
import 'package:pharma_express/models/pharmacy.dart';
import 'package:pharma_express/properties/app_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

class MedocService {
  final pool = MySQLConnectionPool(
    host: '167.172.143.106',
    port: 3306,
    userName: 'pharma_express_user',
    password: 'qja8bw7p5kwuy5ppmeek',
    maxConnections: 10,
    databaseName: 'pharma_express',
  );

  Future<List<Medoc>> getMedocs(
    String query, {
    Map<String, dynamic> params,
  }) async {
    try {
      var result = await pool.execute(
        query,
        params,
      );
      List<Medoc> medocs = [];

      for (final row in result.rows) {
        var json = row.assoc();
        print(num.parse(json['id']));
        print(json['name']);
        print(json['serie_number']);
        print(json['location']);
        print(json['description']);

        medocs.add(Medoc(
          id: num.parse(json['id']),
          name: json['name'] as String,
          number: json['serie_number'] as String,
          description: json['description'] as String,
          avatar: json['avatar'] as String,
        ));
      }
      print("Medocs.length");
      print(medocs.length);
      print(medocs.first);

      return medocs;
    } catch (e) {
      print("errorrrr");
      print(e);
    }
  }

  Future<List<Pharmacy>> getPharmacies(
    int id, {
    Map<String, dynamic> params,
  }) async {
    var result = await pool.execute(
        "SELECT * FROM pharmacy_medicaments WHERE medicament_id = :id",
        {"id": id});
    List<Pharmacy> pharmacys = [];

    for (final row in result.rows) {
      var data = row.assoc();

      var pharms = await pool.execute("SELECT * FROM pharmacies WHERE id = :id",
          {"id": num.parse(data['pharmacie_id'])});
      for (final roww in pharms.rows) {
        var json = roww.assoc();
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
    }
    print("pharmacys.length");
    print(pharmacys.length);
    print(pharmacys.first);

    return pharmacys;
  }
}
