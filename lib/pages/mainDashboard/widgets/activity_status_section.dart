import 'package:flutter/material.dart';

class ActivityStatusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _activityCard("Heart Rate", "78 BPM", "3mins ago", Colors.pinkAccent),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child:
                    _miniCard("Water Intake", "4 Liters", "Real time updates")),
            SizedBox(width: 8),
            Expanded(child: _miniCard("Sleep", "8h 20m", "Updated just now")),
          ],
        )
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
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: color)),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(time,
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          Spacer(),
          // Add graph here if needed
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
