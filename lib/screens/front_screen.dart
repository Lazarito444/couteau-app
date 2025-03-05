import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FrontScreen extends StatelessWidget {
  const FrontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Couteau",
      ),
      drawer: Sidebar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: AssetImage("assets/images/toolbox.png"),
          ),
        ),
      ),
    );
  }
}
