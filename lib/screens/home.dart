// ignore_for_file: must_be_immutable
// ignore_for_file: deprecated_member_use, must_call_super

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:pharma_express/properties/app_properties.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_express/screens/medocs/medocs.dart';
import 'package:pharma_express/screens/pharmacy/pharmacy.dart';
import 'package:pharma_express/screens/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 1);

  int maxCount = 3;

  /// widget list
  final List<Widget> bottomBarPages = [
    PharmacyListPage(),
    MedocsListPage(),
    SettingPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final spinkit = const SpinKitRing(
    color: green,
    lineWidth: 3.0,
    size: 40,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: white,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            bottomBarPages.length,
            (index) => bottomBarPages[index],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                pageController: _pageController,
                color: white,
                showLabel: false,
                notchColor: Colors.green.shade900,
                bottomBarItems: [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home_filled,
                      color: Colors.green.shade900,
                    ),
                    activeItem: const Icon(
                      Icons.home_filled,
                      color: white,
                    ),
                    itemLabel: 'Home',
                  ),

                  ///svg example
                  BottomBarItem(
                    inActiveItem: SvgPicture.asset(
                      'assets/search_icon.svg',
                      color: Colors.green.shade900,
                    ),
                    activeItem: SvgPicture.asset(
                      'assets/search_icon.svg',
                      color: white,
                    ),
                    itemLabel: 'Recherche',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.phone,
                      color: Colors.green.shade900,
                    ),
                    activeItem: const Icon(
                      Icons.phone,
                      color: white,
                    ),
                    itemLabel: 'Parametre',
                  ),
                ],
                onTap: (index) {
                  /// control your animation using page controller
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                  );
                },
              )
            : null,
      ),
    );
  }

  openWhatsapp() async {
    var whatsapp = "+221761908099";
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text= ";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse(" ")}";
    // await launch(appStoreUrl, forceSafariVC: false);

    if (Platform.isIOS) {
      // for iOS phone only

      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        show(
          "L'application Whatsapp n'est pas installé sur cet appareil !",
          duration: Duration(seconds: 5),
        );
        launch("tel://221761908099");
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        show(
          "L'application Whatsapp n'est pas installé sur cet appareil !",
          duration: Duration(seconds: 5),
        );
        launch("tel://221761908099");
      }
    }
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        backgroundColor: blue10,
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        duration: duration,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow, child: const Center(child: Text('Page 1')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Center(child: Text('Page 2')));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red, child: const Center(child: Text('Page 3')));
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue, child: const Center(child: Text('Page 4')));
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreenAccent,
        child: const Center(child: Text('Page 4')));
  }
}
