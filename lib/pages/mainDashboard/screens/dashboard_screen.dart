import 'package:fitness/pages/mainDashboard/widgets/logoutButton.dart';
import 'package:flutter/material.dart';
import '../widgets/bmi_card.dart';
import '../widgets/today_target_card.dart';
import '../widgets/activity_status_section.dart';
import '../widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;

  const DashboardScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome Back,", style: TextStyle(color: Colors.grey[600])),
              Text(userName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              BmiCard(),
              SizedBox(height: 12),
              TodayTargetCard(),
              SizedBox(height: 24),
              Text("Activity Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 12),
              ActivityStatusSection(),
              SizedBox(height: 20),
              LogoutButton(),
              const SizedBox(height: 20), // extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
