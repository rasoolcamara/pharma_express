import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma_express/models/medocs.dart';
import 'package:pharma_express/models/pharmacy.dart';
import 'package:pharma_express/properties/app_properties.dart';
import 'package:pharma_express/screens/pharmacy/details.dart';
import 'package:pharma_express/services/medoc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MedocsListPage extends StatefulWidget {
  MedocsListPage({
    Key? key,
  }) : super(key: key);

  @override
  _MedocsListPageState createState() => _MedocsListPageState();
}

class _MedocsListPageState extends State<MedocsListPage> {
  String status = 'all';
  TextEditingController _searchController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String searchString = "SELECT * FROM medicaments";
  List<Pharmacy> _pharmacyList = [];

  // final List<Order> orders = [];
  bool _loader = false;

  final spinkit = const SpinKitRing(
    color: blue10,
    lineWidth: 3.0,
    size: 40,
  );

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  List<Medoc> _medocList = [];
  List<Medoc> _medocsSeachingList = [];
  bool _searching = false;

  late Future<void> _initMedocData;

  void initState() {
    super.initState();
    _initMedocData = _initMedocs();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.green.shade800,
          title: const Text(
            "Médicaments",
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
          future: _initMedocData,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                key: refreshkey,
                backgroundColor: Colors.white,
                color: blue10,
                onRefresh: () => _refreshMedocs(context),
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
                                              _medocList.isNotEmpty) ||
                                          (_searching == true &&
                                              _medocsSeachingList.isNotEmpty)
                                      ? Container(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 190),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: ListView.builder(
                                            itemCount: _searching == false
                                                ? _medocList.length
                                                : _medocsSeachingList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (_searching == false) {
                                                Medoc medoc = _medocList[index];
                                                return _buildList(
                                                    medoc, context);
                                              } else {
                                                Pharmacy pharmacy =
                                                    _pharmacyList[index];
                                                return _pharmacyBuildList(
                                                    pharmacy, context);
                                              }
                                            },
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 100),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          // width: double.infinity,
                                          child: const Center(
                                            child: Text(
                                              "Pas encore de médicaments",
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
          borderRadius: const BorderRadius.all(
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
                  // setState(() {
                  //   if (value.length > 1) {
                  //     _searching = true;

                  //     var list = _medocList
                  //         .where((Medoc Medoc) => (Medoc.name
                  //             .toLowerCase()
                  //             .contains(value.toLowerCase())))
                  //         .toList();

                  //     _medocsSeachingList = list;
                  //   } else {
                  //     _searching = false;
                  //   }
                  // });
                },
                onFieldSubmitted: (value) async {
                  setState(() {
                    _searching = true;
                    _loader = true;

                    var list = _medocList
                        .where((Medoc Medoc) => (Medoc.name
                            .toLowerCase()
                            .contains(value.toLowerCase())))
                        .toList();

                    _medocsSeachingList = list;
                  });
                  if (_medocsSeachingList.isNotEmpty) {
                    _pharmacyList = await MedocService()
                        .getPharmacies(_medocsSeachingList.first.id);
                    setState(() {
                      _loader = false;
                    });
                  } else {
                    setState(() {
                      _loader = false;
                      _searching = false;
                    });
                  }
                  // setState(() {
                  //   _searchController.clear();
                  //   _searching = false;
                  //   _medocsSeachingList = [];
                  // })
                },
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
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
                  hintStyle: const TextStyle(fontSize: 12.0, color: gray),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initMedocs() async {
    final Medocs = await MedocService().getMedocs(
        searchString == "SELECT * FROM medicaments"
            ? searchString
            : "SELECT * FROM medicaments WHERE name = :name",
        params: {"name": searchString});

    // setState(() {
    // });
    _medocList = Medocs;
  }

  Future<void> _refreshMedocs(BuildContext context) async {
    print("Here");
    final Medocs = await MedocService().getMedocs(
        searchString == "SELECT * FROM medicaments"
            ? searchString
            : "SELECT * FROM medicaments WHERE name = :name",
        params: {"name": searchString});

    setState(() {
      _medocList = Medocs;
      _loader = false;
    });
  }

  Widget _buildList(Medoc medoc, context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
      child: InkWell(
        onTap: () async {
          /* _pharmacyList = await MedocService().getPharmacies(medoc.id);
          // setState(() {

          // });
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 16.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 18,
                                    ),
                                    child: Text(
                                      "Pharmacies ayant ce médicament en stock",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12.5),
                                        letterSpacing: 1.1,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    // height: 500,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _pharmacyList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Pharmacy pharmacy =
                                            _pharmacyList[index];
                                        return pharmacyList(
                                          context,
                                          pharmacy,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ); */
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
                  height: 110.0,
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
                          medoc.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(12),
                            letterSpacing: 1.0,
                            color: Colors.green.shade900,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      // Localisation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.numbers_rounded,
                            size: 16.0,
                            color: Colors.green.shade900,
                          ),
                          const SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            medoc.number,
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

                      // Status
                      Container(
                        width: ScreenUtil().setWidth(210),
                        child: Text(
                          medoc.description.substring(0, 55) + "...",
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: black,
                          ),
                          maxLines: 3,
                        ),
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

  Widget pharmacyList(BuildContext context, Pharmacy pharmacy) {
    return Container(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        children: <Widget>[
          _pharmacyItem(context, pharmacy),
          const Divider(
            color: Colors.black12,
          ),
        ],
      ),
    );
  }

  Widget _pharmacyItem(BuildContext context, Pharmacy pharmacy) {
    return InkWell(
      onTap: () async {},
      child: ListTile(
        title: Text(
          pharmacy.name,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(11),
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
        subtitle: Text(
          pharmacy.location + "\n" + pharmacy.phone,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(10),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _pharmacyBuildList(Pharmacy pharmacy, context) {
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
