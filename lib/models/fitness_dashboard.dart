import 'package:flutter/material.dart';

import 'water_reminder.dart';
import 'bmi_calculator.dart';
import 'bmr_calculator.dart';
import 'fitness_tips.dart';

class FitnessDashboard extends StatefulWidget {
  @override
  _FitnessDashboardState createState() => _FitnessDashboardState();
}

class _FitnessDashboardState extends State<FitnessDashboard> {
  int _currentIndex = 0;

  final screens = [
    WaterReminderScreen(),
    BMICalculatorScreen(),
    BMRCalculatorScreen(),
    FitnessTipsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.water_drop), label: "Water"),
          BottomNavigationBarItem(
              icon: Icon(Icons.monitor_weight), label: "BMI"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "BMR"),
          BottomNavigationBarItem(
              icon: Icon(Icons.tips_and_updates), label: "Tips"),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
