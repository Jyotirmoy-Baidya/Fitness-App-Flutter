import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaterIntakeTracker extends StatefulWidget {
  @override
  _WaterIntakeTrackerState createState() => _WaterIntakeTrackerState();
}

class _WaterIntakeTrackerState extends State<WaterIntakeTracker> {
  double _totalIntake = 0; // in ml
  int waterIntakeTarget = 2000; // default: 2000ml = 2L
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchTodayData();
    _loadTargets();
  }

  /// Fetch user's water intake target from their Firestore document
  Future<void> _loadTargets() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('targets')
          .doc('today')
          .get();

      if (doc.exists) {
        setState(() {
          waterIntakeTarget = (doc.data()?['waterIntake'] ?? 2) * 1000;
        });
      }
    }
  }

  /// Fetch current user's water intake for today
  void _fetchTodayData() async {
    final today = DateTime.now();
    final docId = "${today.year}-${today.month}-${today.day}";

    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('waterIntake')
          .doc(docId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _totalIntake = snapshot.data()?['intake'] ?? 0;
        });
      }
    }
  }

  /// Add or remove water intake amount for today
  void _addIntake(double amount) async {
    final today = DateTime.now();
    final docId = "${today.year}-${today.month}-${today.day}";

    setState(() {
      _totalIntake += amount;
      if (_totalIntake < 0) _totalIntake = 0;
    });

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('waterIntake')
          .doc(docId)
          .set({
        'intake': _totalIntake,
        'date': today,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_totalIntake / waterIntakeTarget).clamp(0.0, 1.0);

    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vertical Progress Bar
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: 10,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 200 * progress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/activity/water-measure.png',
                  height: 210,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Water Intake",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${(_totalIntake / 1000).toStringAsFixed(1)} Liters",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Real Time Updates",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _addIntake(100),
                        child: const Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor:
                              const Color.fromARGB(255, 75, 160, 230),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _addIntake(-100),
                        child: const Icon(Icons.remove),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor:
                              const Color.fromARGB(255, 244, 98, 54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
