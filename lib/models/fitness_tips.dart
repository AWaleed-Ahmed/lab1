import 'package:flutter/material.dart';

class FitnessTipsScreen extends StatelessWidget {
  final List<String> tips = [
    "Stay hydrated",
    "Exercise 30 mins daily",
    "Eat a balanced diet",
    "Avoid processed food",
    "Take enough sleep"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Tips"),
        backgroundColor: Colors.teal,  // same teal color
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ListView.separated(
          itemCount: tips.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.0),
          itemBuilder: (context, index) => ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: Colors.teal,  // teal icons
            ),
            title: Text(
              tips[index],
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blueAccent,  // blue accent text like BMI result
              ),
            ),
            tileColor: Colors.teal.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
        ),
      ),
    );
  }
}
