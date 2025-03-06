import 'package:couteau/screens/about_screen.dart';
import 'package:couteau/screens/age_screen.dart';
import 'package:couteau/screens/country_colleges_screen.dart';
import 'package:couteau/screens/front_screen.dart';
import 'package:couteau/screens/gender_screen.dart';
import 'package:couteau/screens/pokemon_screen.dart';
import 'package:couteau/screens/weather_screen.dart';
import 'package:flutter/material.dart';

const String kInitialRoute = "/";

final Map<String, Widget Function(BuildContext ctx)> kRoutes = {
  "/": (ctx) => FrontScreen(),
  "/gender-predict": (ctx) => GenderScreen(),
  "/age-predict": (ctx) => AgeScreen(),
  "/country-colleges": (ctx) => CountryCollegesScreen(),
  "/dr-weather": (ctx) => WeatherScreen(),
  "/pokemon-info": (ctx) => PokemonScreen(),
  "/wordpress-news": (ctx) => Scaffold(),
  "/about": (ctx) => AboutScreen(),
};
