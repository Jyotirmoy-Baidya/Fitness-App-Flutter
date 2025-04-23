import 'package:flutter/material.dart';

class SleepTrackerPage extends StatelessWidget {
  const SleepTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7C7C),
        title: const Text(
          'Sleep Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // or however many PNGs you have
        itemBuilder: (context, index) {
          final imageIndex = index + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/sleep/$imageIndex.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
