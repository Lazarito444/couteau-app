import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          size: 34,
        ),
        color: Colors.white,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      backgroundColor: Colors.blue,
      title: Text(
        title,
        style: GoogleFonts.gabarito(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
