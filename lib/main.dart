import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pharma_express/models/pharmacy.dart';
import 'package:pharma_express/screens/home.dart';
import 'package:pharma_express/screens/pharmacy/pharmacy.dart';
import 'package:pharma_express/services/pharmacy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Pharmacy> pharmacys = [];

  String searchString = "SELECT * FROM pharmacies";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'DigiTax',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            primarySwatch: Colors.teal,
            fontFamily: "Montserrat",
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 0.8.sp),
          ),
          home: child,
        );
      },
      child: HomePage(),
    );
    /* return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
                decoration: const InputDecoration(
                  hintText: 'Recherche',
                ),
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                    print(searchString);
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    searchString = value;
                    print(searchString);
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: PharmacyService().getPharmacies(
                    searchString == "SELECT * FROM pharmacies"
                        ? searchString
                        : "SELECT * FROM pharmacies WHERE nom = :nom",
                    params: {"nom": searchString}),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      pharmacys = snapshot.data;
                      return ListView.builder(
                        itemCount: pharmacys.length,
                        itemBuilder: (context, index) {
                          final pharmacy = pharmacys[index];
                          return _buildList(pharmacy, context);
                          //  ListTile(
                          //   title: Text(
                          //     pharmacy['nom'],
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          //   subtitle: Text(
                          //     pharmacy['adresse'],
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // );
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
    ); */
  }

  Widget _buildList(dynamic pharmacy, context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 12.0, right: 12.0),
      child: InkWell(
        onTap: () {
          // _showActions(context, place);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              // color: blue.withOpacity(0.05),
            ),
            child: ListTile(
              title: Text(
                pharmacy['nom'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.0,
                  // color: blue10,
                ),
                textScaleFactor: 0.9,
              ),
              // trailing: Text(
              //   place.status == 'untaken' ? "Libre" : "Occupée",
              //   style: TextStyle(
              //     fontSize: 13.0,
              //     color: place.status == 'taken' ? green : orange,
              //   ),
              // ),
              //  place.status == 'untaken' ?
              subtitle: Text(
                pharmacy['adresse'],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
