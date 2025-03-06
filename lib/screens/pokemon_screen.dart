// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _data;
  Widget? content;

  Future<void> _onSubmit() async {
    String typedName = _controller.text.trim().toLowerCase();

    if (typedName.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Pokémon requerido"),
          content: Text(
              "Por favor, ingrese el nombre de un Pokémon para mostrar sus datos."),
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

    final Uri uri = Uri.parse("https://pokeapi.co/api/v2/pokemon/$typedName");
    http.Response response = await http.get(uri);

    typedName = typedName[0].toUpperCase() + typedName.substring(1);

    if (response.statusCode >= 400) {
      if (!context.mounted) return;

      if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Pokémon no encontrado"),
            content: Text(
                "No pudimos encontrar a este Pokémon, asegúrate que esté bien escrito."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Entendido"),
              )
            ],
          ),
        );
      } else {
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
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    late String imageUrl =
        responseData["sprites"]["other"]["official-artwork"]["front_default"];
    String habilidades = "Habilidad(es)";

    for (int i = 0; i < responseData["abilities"].length; i++) {
      String habilidad = responseData["abilities"][i]["ability"]["name"];
      habilidades += "\n$habilidad";
    }

    setState(() {
      _isLoading = false;
      _data = responseData;

      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            typedName,
            style: GoogleFonts.gabarito(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Experiencia base: ${_data!["base_experience"].toString()}",
            style: GoogleFonts.gabarito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            habilidades,
            textAlign: TextAlign.center,
            style: GoogleFonts.gabarito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
        title: "Información de Pokémon",
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
                  labelText: "Nombre del Pokémon",
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
                  "Mostrar Información",
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
