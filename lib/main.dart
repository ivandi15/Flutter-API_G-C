import 'package:flutter/material.dart';
import 'gempa.dart'; // Import halaman gempa
import 'cuaca.dart'; // Import halaman cuaca

void main() {
  runApp(BMKGApp());
}

class BMKGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMKG App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: BMKGHomePage(),
    );
  }
}

class BMKGHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '🌐 DATA BMKG',
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // Card Info Cuaca
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.cloud, color: Colors.blue[200], size: 40),
                        SizedBox(height: 10),
                        Text(
                          'Informasi Cuaca',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lihat prakiraan cuaca terkini di berbagai wilayah Indonesia. Data mencakup suhu, kelembapan, dan kondisi harian.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CuacaPage()),
                            );
                          },
                          child: Text('LIHAT CUACA'),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Card Info Gempa
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange[300], size: 40),
                        SizedBox(height: 10),
                        Text(
                          'Informasi Gempa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Dapatkan data gempa terkini seperti lokasi, magnitudo, waktu, dan potensi tsunami yang terjadi di Indonesia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GempaPage()),
                            );
                          },
                          child: Text('LIHAT GEMPA'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
