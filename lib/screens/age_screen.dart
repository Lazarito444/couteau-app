// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _data;
  Widget? content;

  Future<void> _onSubmit() async {
    final String typedName = _controller.text;

    if (typedName.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Nombre requerido"),
          content: Text("Por favor, ingrese un nombre."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Entendido"),
            )
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final Uri uri = Uri.https("api.agify.io", "/", {"name": typedName});
    http.Response response = await http.get(uri);

    if (response.statusCode >= 400) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Ocurrió un error, por favor, intenta más tarde."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Entendido"),
            )
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData["age"] == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Nombre raro"),
          content: Text("No podemos predecir la edad de este nombre"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Entendido"),
            )
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    late String imageUrl;
    late String ageStatus;
    if (responseData["age"] < 18) {
      ageStatus = "Joven";
      imageUrl =
          "https://static.vecteezy.com/system/resources/previews/017/038/752/non_2x/cartoon-little-boy-happy-smiling-standing-free-vector.jpg";
    } else if (responseData["age"] < 50) {
      ageStatus = "Adulto";
      imageUrl =
          "https://w7.pngwing.com/pngs/707/721/png-transparent-guy-boy-smart-man-people-male-person-young-adult-smile-thumbnail.png";
    } else {
      ageStatus = "Anciano";
      imageUrl =
          "https://aprende.guatemala.com/wp-content/uploads/2022/11/Dia-del-Adulto-Mayor-en-Guatemala-3.jpg";
    }

    setState(() {
      _isLoading = false;
      _data = responseData;

      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _data!["name"] as String,
            style: GoogleFonts.gabarito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            _data!["age"].toString(),
            style: GoogleFonts.gabarito(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade400,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            ageStatus,
            style: GoogleFonts.gabarito(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Image.network(
            imageUrl,
            height: 200,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Predicción de Edad",
      ),
      drawer: Sidebar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: _onSubmit,
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 24,
                  ),
                ),
                child: Text(
                  "Predecir Edad",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : content != null
                      ? content!
                      : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
