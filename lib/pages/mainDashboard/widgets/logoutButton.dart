import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/beforeLoginPages/first_screen.dart';
import 'package:fitness/pages/home_page.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _auth.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false, // This removes all previous screens from the stack
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.logout, size: 18, color: Colors.white),
      label: const Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
