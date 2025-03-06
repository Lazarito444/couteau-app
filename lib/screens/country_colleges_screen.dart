// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CountryCollegesScreen extends StatefulWidget {
  const CountryCollegesScreen({super.key});

  @override
  State<CountryCollegesScreen> createState() => _CountryCollegesState();
}

class _CountryCollegesState extends State<CountryCollegesScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _data = [];
  Widget content = SizedBox.shrink();

  Future<void> _onSubmit() async {
    if (_controller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Ingresa un país"),
          content: Text(
              "Ingresa el nombre (en inglés) de un país para enseñarte sus universidades"),
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

    _controller.text = _controller.text.trim();
    setState(() {
      content = SizedBox.shrink();
      _isLoading = true;
    });

    final Uri uri = Uri.parse(
        "http://universities.hipolabs.com/search?country=${_controller.text}");
    final http.Response response = await http.get(uri);
    final List<dynamic> responseData = json.decode(response.body);
    _data = responseData.cast<Map<String, dynamic>>();

    if (_data.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("País incorrecto"),
          content: Text(
              "Ingresa el nombre (en inglés) de un país para enseñarte sus universidades"),
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
      content = ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue.shade50,
          child: ListTile(
            title: Text(
              _data[index]["name"].toString(),
              style: GoogleFonts.gabarito(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 0.93,
              ),
            ),
            subtitle: Text(
              "${_data[index]["domains"][0].toString()}\n${_data[index]["web_pages"][0]}",
              style: GoogleFonts.gabarito(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Universidades de países",
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
                  labelText: "Nombre del país (en inglés)",
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
                  "Buscar Universidades",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (_isLoading)
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              // ignore: unnecessary_null_comparison
              if (_data != null || _data.isNotEmpty)
                SizedBox(width: double.infinity, height: 430, child: content)
            ],
          ),
        ),
      ),
    );
  }
}
