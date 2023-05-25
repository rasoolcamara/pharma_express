import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

String appTitile = "Pharma Express";
const String apiURL = "http://localhost:90/api/";

const String baseURL = "http://localhost:90/storage/";

String currentCountry = "SN";
ConnectivityResult connectivityResult = ConnectivityResult.none;

const Color blue = Color(0xFF1971D4);
const Color blue10 = Color(0xff1487DD);
const Color yellow = Color(0xffF8BB18);
const Color yellow10 = Color(0xffE6AC4B);
const Color orange = Color(0xffF55A00);
const Color black = Color(0xff1A1A1A);
const Color white = Color(0xffF3F4F5);
const Color gray = Color(0xffA7A7A7);
const Color red = Color(0xffF0142F);
const Color red10 = Color.fromRGBO(178, 0, 0, 0.08);
const Color green = Color(0xff1FB552);
