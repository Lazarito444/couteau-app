import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.construction,
                    color: Colors.white,
                    size: 70,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Couteau",
                    style: GoogleFonts.gabarito(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              children: <Widget>[
                ListTile(
                  onTap: () => Navigator.of(context).pushReplacementNamed("/"),
                  leading: Icon(
                    Icons.star_rounded,
                    size: 30,
                  ),
                  title: Text("Portada"),
                ),
                ListTile(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed("/gender-predict"),
                  leading: Icon(
                    Icons.male_rounded,
                    size: 30,
                  ),
                  title: Text("Predecir género"),
                ),
                ListTile(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed("/age-predict"),
                  leading: Icon(
                    Icons.elderly_woman_rounded,
                    size: 30,
                  ),
                  title: Text("Predecir edad"),
                ),
                ListTile(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed("/country-colleges"),
                  leading: Icon(
                    Icons.school,
                    size: 30,
                  ),
                  title: Text("Universidades"),
                ),
                ListTile(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed("/dr-weather"),
                  leading: Icon(
                    Icons.cloudy_snowing,
                    size: 30,
                  ),
                  title: Text("Clima en RD"),
                ),
                ListTile(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed("/pokemon-info"),
                  leading: Image.asset(
                    "assets/images/pokeball.png",
                    width: 30,
                  ),
                  title: Text("Pokémon"),
                ),
                ListTile(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed("/wordpress-news"),
                  leading: Icon(
                    Icons.newspaper_rounded,
                    size: 30,
                  ),
                  title: Text("Noticias WordPress"),
                ),
                ListTile(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed("/about"),
                  leading: Icon(
                    Icons.contact_support_rounded,
                    size: 30,
                  ),
                  title: Text("Acerca de"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
