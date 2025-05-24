import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  double bmi = 0;
  String bmiCategory = "";

  void calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        bmi = 0;
        bmiCategory = "Please enter valid height and weight.";
      });
      return;
    }

    final heightInMeters = height / 100;

    setState(() {
      bmi = weight / (heightInMeters * heightInMeters);

      // Determine BMI Category
      if (bmi < 18.5) {
        bmiCategory = "Underweight";
      } else if (bmi >= 18.5 && bmi < 24.9) {
        bmiCategory = "Normal weight";
      } else if (bmi >= 25 && bmi < 29.9) {
        bmiCategory = "Overweight";
      } else {
        bmiCategory = "Obese";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                "Calculate BMI",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 24.0),

            Text(
              "Your BMI: ${bmi == 0 ? "--" : bmi.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20.0, color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.0),

            Text(
              bmiCategory,
              style: TextStyle(
                fontSize: 18.0,
                color: bmi == 0 ? Colors.red : Colors.green,
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
