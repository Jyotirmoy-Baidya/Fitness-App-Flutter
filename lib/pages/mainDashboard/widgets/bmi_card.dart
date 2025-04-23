import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BmiCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        width: double.infinity,
        color: Color(0xFFFD9292),
        child: Stack(
          children: [
            // Full background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/home-bubble.png',
                fit: BoxFit.cover,
              ),
            ),
            // BMI card content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BMI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your Body Mass Index",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
