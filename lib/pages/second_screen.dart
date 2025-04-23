import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: user != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user!.photoURL != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user!.photoURL!),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    "Hello, ${user!.displayName ?? 'User'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Email: ${user!.email}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text("No user signed in."),
            ),
    );
  }
}
