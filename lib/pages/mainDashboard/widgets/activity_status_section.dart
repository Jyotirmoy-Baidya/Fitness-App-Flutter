import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityStatusSection extends StatefulWidget {
  @override
  _ActivityStatusSectionState createState() => _ActivityStatusSectionState();
}

class _ActivityStatusSectionState extends State<ActivityStatusSection> {
  double _totalIntake = 0;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _fetchWaterIntake();
  }

  Future<void> _fetchWaterIntake() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final today = DateTime.now();
      final docId = "${today.year}-${today.month}-${today.day}";

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('waterIntake')
          .doc(docId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        setState(() {
          _totalIntake = data?['intake'] ?? 0;
          final timestamp = data?['date'];
          _lastUpdated = timestamp != null && timestamp is Timestamp
              ? timestamp.toDate()
              : null;
        });
      }
    }
  }

  String _getTimeAgoText() {
    if (_lastUpdated == null) return "No recent update";

    final duration = DateTime.now().difference(_lastUpdated!);

    if (duration.inSeconds < 60) return "Just now";
    if (duration.inMinutes < 60) return "${duration.inMinutes} min ago";
    if (duration.inHours < 24) return "${duration.inHours} hrs ago";
    return "${duration.inDays} day${duration.inDays > 1 ? 's' : ''} ago";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _activityCard("Heart Rate", "78 BPM", "3 mins ago", Colors.pinkAccent),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _miniCard(
                "Water Intake",
                "${(_totalIntake / 1000).toStringAsFixed(1)} Liters",
                _getTimeAgoText(),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _miniCard("Sleep", "8h 20m", "Updated just now"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _activityCard(String title, String value, String time, Color color) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: color),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  time,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _miniCard(String title, String value, String subtitle) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
