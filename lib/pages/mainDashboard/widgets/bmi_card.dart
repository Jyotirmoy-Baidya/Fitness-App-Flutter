import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class BmiWidget extends StatefulWidget {
  @override
  _BmiWidgetState createState() => _BmiWidgetState();
}

class _BmiWidgetState extends State<BmiWidget> {
  String? _username;
  String? _weight;
  String? _height;
  double? _bmi;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        final username = data['username']?.toString() ?? '';
        final weight = double.tryParse(data['weight']?.toString() ?? '');
        final height = double.tryParse(data['height']?.toString() ?? '');

        if (username != null) {
          _username = username.toString();
        } else {
          _username = "Hey";
        }
        if (weight != null && height != null && height > 0) {
          double bmi = weight / pow(height / 100, 2);
          setState(() {
            _weight = weight.toString();
            _height = height.toString();
            _bmi = double.parse(bmi.toStringAsFixed(1));
          });
        }
      }
    }
  }

  String getBmiStatus(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "normal weight";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    return _bmi == null
        ? CircularProgressIndicator()
        : Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome Back,",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Hey $_username",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFF7C7C),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BMI (Body Mass Index)",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You have a ${getBmiStatus(_bmi!)}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.purpleAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Your onPressed logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "View More",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: _bmi! / 40,
                            strokeWidth: 8,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purpleAccent),
                          ),
                        ),
                        Text(
                          _bmi!.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
  }
}
