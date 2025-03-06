import 'dart:convert';
import 'package:couteau/secrets.dart';
import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final double _latitude = 18.475838171727702;
  final double _longitude = -69.89867218902359;
  String? _weatherDescription;
  double? _temperature;
  bool _loading = true;
  String _errorMessage = '';

  Future<void> _getLocation() async {
    await _getWeather(18.475838171727702, -69.89867218902359);
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=${Secrets.weatherApiKey}");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherDescription = data['weather'][0]['main'].toString();
        _temperature = data['main']['temp'].toDouble();
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo obtener el clima';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Clima en RD"),
      drawer: Sidebar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : Center(
                    child: Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Clima en Santo Domingo',
                              style: GoogleFonts.gabarito(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade600,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Latitud: $_latitude',
                              style: GoogleFonts.gabarito(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Longitud: $_longitude',
                              style: GoogleFonts.gabarito(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Temperatura: ${_temperature?.toStringAsFixed(1)}°C',
                              style: GoogleFonts.gabarito(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Descripción del clima: $_weatherDescription',
                              style: GoogleFonts.gabarito(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
