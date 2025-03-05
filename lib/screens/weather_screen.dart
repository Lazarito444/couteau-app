import 'dart:convert';
import 'package:couteau/secrets.dart';
import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final Location _location = Location();
  double? _latitude;
  double? _longitude;
  String? _weatherDescription;
  double? _temperature;
  bool _loading = true;
  String _errorMessage = '';

  Future<void> _getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _loading = false;
          _errorMessage = 'No se pudo habilitar el servicio de ubicación';
        });
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _loading = false;
          _errorMessage = 'No se tiene permiso para acceder a la ubicación';
        });
        return;
      }
    }

    LocationData locationData = await _location.getLocation();

    setState(() {
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;
    });

    if (_latitude != null && _longitude != null) {
      await _getWeather(18.475838171727702, -69.89867218902359);
    }
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
                              'Latitud: ${_latitude ?? 'No disponible'}',
                              style: GoogleFonts.gabarito(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Longitud: ${_longitude ?? 'No disponible'}',
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
