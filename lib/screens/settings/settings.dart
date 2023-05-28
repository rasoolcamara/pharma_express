// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pharma_express/properties/app_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _countryCode = "+221";

  bool _loading = false;

  final spinkit = SpinKitRing(
    color: Colors.green.shade900,
    lineWidth: 3.0,
    size: 40,
  );

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        title: Text(
          "Services d'Urgence",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: _loading
          ? spinkit
          : ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      // height: _height,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 90,
                            // width: 350,
                            decoration: BoxDecoration(
                              // image: DecorationImage(
                              //   image: AssetImage('assets/images/home.png'),
                              //   fit: BoxFit.cover,
                              // ),
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: Text(
                                  "Retrouver les numéros de services d'urgences de la ville de Thiès.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Divider(
                            height: 1.0,
                            color: gray,
                          ),
                          // Update infos
                          // liste des agents
                          InkWell(
                            onTap: () {
                              print("Contacter un de nos agents");
                              // ignore: deprecated_member_use
                              launch("tel://+221775000000");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                right: 5.0,
                                left: 10.0,
                              ),
                              child: ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.green.shade900,
                                    size: 25,
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    "Numéro d'urgence Mairie de Thiès",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    "33 839 78 89",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Divider(
                            height: 1.0,
                            color: gray,
                          ),
                          // Modifier mdp
                          InkWell(
                            onTap: () {
                              print("Contacter un de nos agents");
                              // ignore: deprecated_member_use
                              launch("tel://+221775000000");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                                left: 10.0,
                              ),
                              child: ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.green.shade900,
                                    size: 25,
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    "Sapeurs Pompiers",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    "33 839 78 89",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Divider(
                            height: 1.0,
                            color: gray,
                          ),
                          // Contacter un de nos agents
                          InkWell(
                            onTap: () {
                              print("Contacter un de nos agents");
                              // ignore: deprecated_member_use
                              launch("tel://+221775000000");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                                left: 10.0,
                              ),
                              child: ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.green.shade900,
                                    size: 25,
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    "Urgence Hopital Régional",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    "33 839 78 89",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // _customAlertDialog(
  //   String title,
  //   String body,
  //   AlertDialogType type, {
  //   VoidCallback callback,
  // }) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomAlertDialog(
  //         type: type,
  //         title: title,
  //         content: body,
  //         callback: callback,
  //       );
  //     },
  //   );
  // }

  void _callSAV() async {
    if (!await launch("tel://+221776738631")) throw 'Could not launch tel';
  }
}
