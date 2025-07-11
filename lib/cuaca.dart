import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class CuacaPage extends StatefulWidget {
  @override
  _CuacaPageState createState() => _CuacaPageState();
}

class _CuacaPageState extends State<CuacaPage> {
  List<Map<String, String>> cuacaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCuacaData();
  }

  Future<void> fetchCuacaData() async {
    final url = Uri.parse('https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-Indonesia.xml');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final areaList = document.findAllElements('area');

        List<Map<String, String>> dataList = [];

        for (var area in areaList) {
          String name = area.getAttribute('description') ?? 'Wilayah Tidak Diketahui';

          var weatherElement = area.findElements('parameter').firstWhere(
            (e) => e.getAttribute('id') == 'weather',
            orElse: () => xml.XmlElement(xml.XmlName('empty')),
          );

          if (weatherElement.name.local != 'empty') {
            var weatherValues = weatherElement.findAllElements('value').toList();
            if (weatherValues.isNotEmpty) {
              String weatherCode = weatherValues.first.text;
              String weatherDesc = getWeatherDescription(weatherCode);

              dataList.add({
                'wilayah': name,
                'cuaca': weatherDesc,
                'kode': weatherCode,
              });
            }
          }
        }

        setState(() {
          cuacaList = dataList;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data cuaca');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  String getWeatherDescription(String code) {
    switch (code) {
      case '0': return 'Cerah';
      case '1': return 'Cerah Berawan';
      case '2': return 'Berawan';
      case '3': return 'Berawan Tebal';
      case '4': return 'Kabut';
      case '5': return 'Hujan Ringan';
      case '10': return 'Hujan Sedang';
      case '60': return 'Hujan Petir';
      case '95': return 'Hujan Lebat';
      default: return 'Tidak Diketahui';
    }
  }

  IconData getWeatherIcon(String code) {
    switch (code) {
      case '0': return Icons.wb_sunny;
      case '1': return Icons.wb_cloudy;
      case '2': return Icons.cloud;
      case '3': return Icons.cloud_queue;
      case '4': return Icons.blur_on;
      case '5': return Icons.grain;
      case '10': return Icons.beach_access;
      case '60': return Icons.flash_on;
      case '95': return Icons.thunderstorm;
      default: return Icons.help_outline;
    }
  }

  Widget buildCuacaCard(Map<String, String> data) {
    final weatherCode = data['kode'] ?? '';
    final icon = getWeatherIcon(weatherCode);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey[900]!, Colors.blueGrey[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black87.withOpacity(0.6),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.amberAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['wilayah'] ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 6),
                Text(
                  data['cuaca'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.blueGrey,
                onRefresh: fetchCuacaData,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0, bottom: 16),
                      child: Column(
                        children: [
                          Icon(Icons.cloud, size: 50, color: Colors.lightBlueAccent),
                          SizedBox(height: 10),
                          Text(
                            'Prakiraan Cuaca',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'BMKG - Seluruh Wilayah Indonesia',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    ...cuacaList.map((item) => buildCuacaCard(item)).toList(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}
