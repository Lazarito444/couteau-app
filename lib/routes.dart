import 'package:couteau/screens/front_screen.dart';
import 'package:couteau/screens/gender_screen.dart';
import 'package:flutter/material.dart';

const String kInitialRoute = "/";

final Map<String, Widget Function(BuildContext ctx)> kRoutes = {
  "/": (ctx) => FrontScreen(),
  "/gender-predict": (ctx) => GenderScreen(),
  "/age-predict": (ctx) => Scaffold(),
  "/country-colleges": (ctx) => Scaffold(),
  "/dr-weather": (ctx) => Scaffold(),
  "/pokemon-info": (ctx) => Scaffold(),
  "/wordpress-news": (ctx) => Scaffold(),
  "/about": (ctx) => Scaffold(),
};
