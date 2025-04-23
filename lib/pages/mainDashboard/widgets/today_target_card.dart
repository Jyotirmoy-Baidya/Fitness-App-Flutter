import 'package:flutter/material.dart';

class TodayTargetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFE9F0FF),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Today Target", style: TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {},
            child: Text("Check"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFA8A8),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
