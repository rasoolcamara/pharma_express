// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_express/models/pharmacy.dart';
import 'package:pharma_express/properties/app_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PharmacyDetailsPage extends StatefulWidget {
  PharmacyDetailsPage({
    Key? key,
    required this.pharmacy,
  }) : super(key: key);
  Pharmacy pharmacy;

  @override
  _PharmacyDetailsPageState createState() => _PharmacyDetailsPageState();
}

class _PharmacyDetailsPageState extends State<PharmacyDetailsPage> {
  // CustomerService customerService = CustomerService();

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool firstAccess = false;

  bool _loading = false;

  late bool imageAccepted;
  late String _mapStyle;

  late String selectedImage;
  late String selectedImageExtension;
  final Set<Marker> _markers = {};
  LatLng _currentPosition = LatLng(14.752238781984246, -17.461802067387016);
  late GoogleMapController _controller;
  final LatLng _center = const LatLng(14.752238781984246, -17.461802067387016);

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _controller.setMapStyle(_mapStyle);
  }

  final spinkit = SpinKitRing(
    color: Colors.green.shade900,
    lineWidth: 3.0,
    size: 40,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _location = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 0.0,
            right: 0.0,
            top: 5.0,
            bottom: 7.0,
          ),
          child: _line(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
            left: 20.0,
            right: 20.0,
            bottom: 10.0,
          ),
          child: Text(
            "Localisation",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 1.5,
              color: green,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          height: 400.0,
          child: GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('caterer_place'),
                position: _currentPosition,
              ),
            },
          ),
        ),
      ],
    );
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
          title: Text(
            widget.pharmacy.name,
            style: const TextStyle(
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
            : SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 5.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: green.withOpacity(0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 160.0,
                                      width: MediaQuery.of(context).size.width /
                                          2.1,
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 0.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 18.0,
                                          ),
                                          Text(
                                            widget.pharmacy.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              letterSpacing: 1.1,
                                              color: Colors.green.shade900,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Text(
                                            widget.pharmacy.phone,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.0,
                                              letterSpacing: 1.0,
                                              color: Colors.black,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          // Localisation
                                          Text(
                                            widget.pharmacy.location,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13.0,
                                              letterSpacing: 1.1,
                                              color: black,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      height: 160.0,
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      decoration: const BoxDecoration(
                                        color: gray,
                                        image: DecorationImage(
                                          opacity: 0.95,
                                          image: AssetImage(
                                            "assets/images/logo/appstore.png",
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0.0,
                                            color: Colors.black87,
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1E2026),
                                            Color(0xFF23252E),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 50.0,
                            left: 20.0,
                            right: 20.0,
                          ),
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 18,
                                ),
                                child: Text(
                                  "Horaires d'ouverture",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(12.5),
                                    letterSpacing: 1.1,
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Lundi:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "09:00 - 18:00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: green,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Mardi:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "09:00 - 18:00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: green,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Mercredi:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "09:00 - 18:00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: green,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Jeudi:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "09:00 - 18:00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: green,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Vendredi:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "09:00 - 18:00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: green,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Samedi:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "Fermé",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: red,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Dimanche:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  "Fermé",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    letterSpacing: 1.1,
                                    color: red,
                                  ),
                                ),
                              ),
                              // _location,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum PhotoSource { gallery, camera }

Widget _line() {
  return Container(
    height: 0.4,
    width: double.infinity,
    color: gray,
  );
}
