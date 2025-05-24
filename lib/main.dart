import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'note_view.dart';
import 'task_view.dart';
import 'fitness/fitness_dashboard.dart';
import 'models/fitness_dashboard.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merged App',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: MyHomePage(onToggleTheme: toggleTheme),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MyHomePage({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> _weatherData;

  @override
  void initState() {
    super.initState();
    _weatherData = fetchWeatherByLocation();
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Map<String, dynamic>> fetchWeatherByLocation() async {
    Position position = await _determinePosition();
    final lat = position.latitude;
    final lon = position.longitude;

    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=52efcfedd336d7ad6def65a3d95739e2&units=metric'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _animatedButton(
      {required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: 1.0,
        duration: Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading weather: ${snapshot.error}',
                  textAlign: TextAlign.center));
        } else if (snapshot.hasData) {
          final weatherData = snapshot.data!;
          final weatherIcon = weatherData['weather'][0]['icon'];
          final weatherDescription = weatherData['weather'][0]['description'];
          final temperature = weatherData['main']['temp'];
          final city = weatherData['name'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 8),
              Text('City: $city', style: TextStyle(fontSize: 16)),
              Text('Temperature: ${temperature.toString()}°C',
                  style: TextStyle(fontSize: 16)),
              Text('Weather: $weatherDescription',
                  style: TextStyle(fontSize: 16)),
            ],
          );
        } else {
          return Center(child: Text('No weather data available'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Hello, User",
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 20),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: _buildWeatherWidget(),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                    child: _animatedButton(
                        label: "Task Manager",
                        onPressed: () => _navigateTo(TaskView()))),
                SizedBox(width: 20),
                Expanded(
                    child: _animatedButton(
                        label: "Expense Manager", onPressed: () {})),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _animatedButton(
                        label: "Notes", onPressed: () => _navigateTo(NoteView()))),
                SizedBox(width: 20),
                Expanded(
                    child: _animatedButton(
                        label: "Fitness",
                        onPressed: () => _navigateTo(FitnessDashboard()))),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _animatedButton(label: "AI Chat", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
