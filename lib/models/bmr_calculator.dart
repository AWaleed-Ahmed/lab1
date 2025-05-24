import 'package:flutter/material.dart';

class BMRCalculatorScreen extends StatefulWidget {
  @override
  _BMRCalculatorScreenState createState() => _BMRCalculatorScreenState();
}

class _BMRCalculatorScreenState extends State<BMRCalculatorScreen> {
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  String gender = "Male";
  double bmr = 0;
  String message = "";

  void calculateBMR() {
    final age = int.tryParse(ageController.text);
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (age == null || height == null || weight == null || age <= 0 || height <= 0 || weight <= 0) {
      setState(() {
        bmr = 0;
        message = "Please enter valid age, height, and weight.";
      });
      return;
    }

    setState(() {
      if (gender == "Male") {
        bmr = 10 * weight + 6.25 * height - 5 * age + 5;
      } else {
        bmr = 10 * weight + 6.25 * height - 5 * age - 161;
      }
      message = "Your BMR indicates your daily calorie needs at rest.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMR Calculator"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
              items: ["Male", "Female"]
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) => setState(() => gender = val!),
            ),
            SizedBox(height: 16.0),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Height (cm)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),

            ElevatedButton(
              onPressed: calculateBMR,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                "Calculate BMR",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 24.0),

            Text(
              "Your BMR: ${bmr == 0 ? "--" : bmr.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20.0, color: Colors.indigoAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.0),

            Text(
              message,
              style: TextStyle(
                fontSize: 18.0,
                color: bmr == 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
