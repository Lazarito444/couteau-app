// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
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

    final Uri uri = Uri.https("api.genderize.io", "/", {"name": typedName});
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
      return;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData["gender"] == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Nombre raro"),
          content:
              Text("Este nombre no se ha podido relacionar con ningún genero"),
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

    setState(() {
      _isLoading = false;
      _data = responseData;

      String gender = _data!["gender"] as String;
      late Color color;
      if (gender == "male") {
        gender = "Masculino";
        color = Colors.blue.shade400;
      } else {
        gender = "Femenino";
        color = Colors.pink.shade200;
      }

      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _data!["name"] as String,
            style: GoogleFonts.gabarito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            gender,
            style: GoogleFonts.gabarito(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${((_data!["probability"] as double) * 100).toStringAsFixed(0)}%',
            style: GoogleFonts.gabarito(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Predicción de Género",
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
                    )),
                child: Text(
                  "Predecir Género",
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
