import 'dart:convert';
import 'package:couteau/widgets/sidebar.dart';
import 'package:couteau/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

class WordpressNewsScreen extends StatelessWidget {
  const WordpressNewsScreen({super.key});

  String cleanString(String input) {
    final unescape = HtmlUnescape();

    final withoutHtmlTags = input.replaceAll(RegExp(r'<[^>]*>'), '');

    return unescape.convert(withoutHtmlTags);
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Enlace copiado al portapapeles"),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadData() async {
    final Uri uri = Uri.parse("https://gizmodo.com/wp-json/wp/v2/posts");
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> newData = data.cast<Map<String, dynamic>>();
      return newData;
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Noticias de Gizmodo",
      ),
      drawer: Sidebar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Center(
          child: FutureBuilder(
            future: _loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error cargando los datos...");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No hay datos disponibles.");
              } else {
                return Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/gizmodo.png",
                      width: 300,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      height: 450,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) => Card(
                          color: Colors.blue.shade50,
                          child: ListTile(
                            onTap: () {
                              copyToClipboard(
                                  context, snapshot.data![index]["link"]);
                            },
                            title: Text(
                              cleanString(
                                  snapshot.data![index]["title"]["rendered"]),
                              style: GoogleFonts.gabarito(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.15,
                              ),
                            ),
                            subtitle: Text(
                              cleanString(
                                  snapshot.data![index]["excerpt"]["rendered"]),
                              style: GoogleFonts.gabarito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
