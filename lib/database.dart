import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Connexion à la base de données MySQL
  Future<MySqlConnection> connect() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '192.168.1.7',
      port: 3306,
      user: 'test_app',
      password: 'test123',
      db: 'pharmacie_db',
    ));
    return conn;
  }

  // Récupération des données de la base de données
  Future<List<ResultRow>> getPharmacies(String query) async {
    final conn = await connect();
    final result = await conn.query(query);
    await conn.close();
    return result.toList();
  }

  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PharmaExpress'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Recherche',
                ),
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getPharmacies("SELECT * FROM pharmacies WHERE nom LIKE '%$searchString%'"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final pharmacies = snapshot.data;
                      return ListView.builder(
                        itemCount: pharmacies.length,
                        itemBuilder: (context, index) {
                          final pharmacy = pharmacies[index];
                          return ListTile(
                            title: Text(pharmacy['nom']),
                            subtitle: Text(pharmacy['adresse']),
                          );
                        },
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
