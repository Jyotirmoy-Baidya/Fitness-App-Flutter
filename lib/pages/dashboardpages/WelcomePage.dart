import 'package:fitness/pages/mainDashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatelessWidget {
  final String userName;

  const WelcomePage({super.key, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40),
            Image.asset(
              'assets/images/welcome-fitness.png', // Replace with your image path
              height: 300,
              fit: BoxFit.contain,
            ),
            Column(
              children: [
                Text(
                  "Welcome, $userName",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "You are all set now, let’s reach your\ngoals together with us",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle next or skip
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(
                        userName: 'Sarthak',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF8C8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 56),
                  elevation: 5,
                  shadowColor: Colors.pinkAccent,
                ),
                child: Text(
                  "Go To Home",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
