import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma_express/models/pharmacy.dart';
import 'package:pharma_express/properties/app_properties.dart';
import 'package:pharma_express/screens/pharmacy/details.dart';
import 'package:pharma_express/services/pharmacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PharmacyListPage extends StatefulWidget {
  PharmacyListPage({
    Key? key,
  }) : super(key: key);

  @override
  _PharmacyListPageState createState() => _PharmacyListPageState();
}

class _PharmacyListPageState extends State<PharmacyListPage> {
  String status = 'all';
  TextEditingController _searchController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String searchString = "SELECT * FROM pharmacies";

  // final List<Order> orders = [];
  bool _loader = false;

  final spinkit = SpinKitRing(
    color: Colors.green.shade900,
    lineWidth: 3.0,
    size: 40,
  );

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  List<Pharmacy> _pharmacyList = [];
  List<Pharmacy> _pharmacysSeachingList = [];
  bool _searching = false;

  late Future<void> _initPharmacyData;

  void initState() {
    super.initState();
    _initPharmacyData = _initPharmacys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        title: const Text(
          "Pharmacies",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder(
        future: _initPharmacyData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              key: refreshkey,
              backgroundColor: Colors.white,
              color: Colors.green.shade900,
              onRefresh: () => _refreshPharmacys(context),
              child: _loader
                  ? spinkit
                  : SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          _search(context),
                          // color: liteGray,
                          Stack(
                            children: <Widget>[
                              Container(
                                // padding: EdgeInsets.only(top: 8),
                                height: MediaQuery.of(context).size.height,
                                width: double.infinity,
                                child: (_searching == false &&
                                            _pharmacyList.isNotEmpty) ||
                                        (_searching == true &&
                                            _pharmacysSeachingList.isNotEmpty)
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 190),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          itemCount: _searching == false
                                              ? _pharmacyList.length
                                              : _pharmacysSeachingList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Pharmacy pharmacy = _searching ==
                                                    false
                                                ? _pharmacyList[index]
                                                : _pharmacysSeachingList[index];
                                            return _buildList(
                                                pharmacy, context);
                                          },
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 100),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        // width: double.infinity,
                                        child: const Center(
                                          child: Text(
                                            "Pas encore d'agent",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          } else {
            return Center(
              child: spinkit,
            );
          }
        },
      ),
    );
  }

  /// Item TextFromField Search
  Padding _search(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 35.0,
      ),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Theme(
              data: ThemeData(
                hintColor: Colors.transparent,
              ),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    if (value.length > 1) {
                      _searching = true;

                      var list = _pharmacyList
                          .where((Pharmacy pharmacy) => (pharmacy.name
                              .toLowerCase()
                              .contains(value.toLowerCase())))
                          .toList();

                      _pharmacysSeachingList = list;
                    } else {
                      _searching = false;
                    }
                  });
                },
                onFieldSubmitted: (value) => {
                  setState(() {
                    _searchController.clear();
                    _searching = false;
                    _pharmacysSeachingList = [];
                  })
                },
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade900,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade900,
                    ),
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: gray,
                    size: 28.0,
                  ),
                  hintText: "Rechercher",
                  hintStyle: TextStyle(fontSize: 12.0, color: gray),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initPharmacys() async {
    final pharmacys = await PharmacyService().getPharmacies(
        searchString == "SELECT * FROM pharmacies"
            ? searchString
            : "SELECT * FROM pharmacies WHERE nom = :nom",
        params: {"nom": searchString});

    // setState(() {
    // });
    _pharmacyList = pharmacys;
  }

  Future<void> _refreshPharmacys(BuildContext context) async {
    print("Here");
    final pharmacys = await PharmacyService().getPharmacies(
        searchString == "SELECT * FROM pharmacies"
            ? searchString
            : "SELECT * FROM pharmacies WHERE nom = :nom",
        params: {"nom": searchString});

    setState(() {
      _pharmacyList = pharmacys;
      _loader = false;
    });
  }

  Widget _buildList(Pharmacy pharmacy, context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => PharmacyDetailsPage(
                pharmacy: pharmacy,
              ),
            ),
          );
        },
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 130.0,
                  width: 90.0,
                  decoration: const BoxDecoration(
                    color: green,
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
                const SizedBox(
                  width: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        height: ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(210),
                        child: Text(
                          pharmacy.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(11),
                            letterSpacing: 1.0,
                            color: Colors.green.shade900,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      // Localisation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            size: 16.0,
                            color: Colors.green.shade900,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            pharmacy.phone,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      // Nombres invités
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on_sharp,
                            size: 16.0,
                            color: Colors.green.shade900,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          pharmacy.location.length > 30
                              ? Container(
                                  height: ScreenUtil().setHeight(25),
                                  width: ScreenUtil().setWidth(200),
                                  child: Center(
                                    child: Text(
                                      pharmacy.location,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(11),
                                        color: black,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                )
                              : Text(
                                  pharmacy.location,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(11),
                                    color: black,
                                  ),
                                  maxLines: 2,
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      // Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.circle,
                            size: 12.0,
                            color: pharmacy.status == 'open' ? green : orange,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            pharmacy.status == 'open' ? "Ouvert" : "Fermé",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: pharmacy.status == 'open' ? green : orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
