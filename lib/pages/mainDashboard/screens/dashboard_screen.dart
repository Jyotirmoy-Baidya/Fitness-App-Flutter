import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/dashboardpages/ProfileFormAfterRegister.dart';
import 'package:fitness/pages/dashboardpages/ProfileFormPages.dart';
import 'package:fitness/pages/mainDashboard/containers/WaterIntake.dart';
import 'package:fitness/pages/mainDashboard/containers/WorkoutTracker.dart';
import 'package:fitness/pages/mainDashboard/pages/MealScreen.dart';
import 'package:fitness/pages/mainDashboard/pages/SleepTrackerPage.dart';
import 'package:fitness/pages/mainDashboard/pages/activities_page.dart';
import 'package:fitness/pages/mainDashboard/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness/pages/mainDashboard/widgets/bmi_card.dart';
import 'package:fitness/pages/mainDashboard/widgets/logoutButton.dart';
import 'package:fitness/pages/mainDashboard/widgets/today_target_card.dart';
import 'package:fitness/pages/mainDashboard/widgets/activity_status_section.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({super.key, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isProfileComplete = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  Future<void> _checkUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = doc.data();
        if (data == null ||
            data['weight'] == null ||
            data['date_of_birth'] == null ||
            data['height'] == null) {
          setState(() {
            _isProfileComplete = false;
          });
        }
      }
    } catch (e) {
      print('Error checking profile: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return ActivitiesPage();
      case 2:
        return MealPlannerPage();
      case 3:
        return ProfilePage();
      default:
        return _buildHomeDashboard();
    }
  }

  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          BmiWidget(),
          const SizedBox(height: 12),
          TodayTargetCard(),
          const SizedBox(height: 24),
          const Text("Activity Status",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ActivityStatusSection(),
          SizedBox(height: 20),
          WaterIntakeTracker(),
          SizedBox(height: 20),
          WorkoutTracker(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isProfileComplete) {
      return ProfileFormAfterRegister(
        onComplete: () async {
          setState(() => _isLoading = true);
          await _checkUserProfile();
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _getSelectedPage()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onNavBarTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0
                  ? 'assets/icons/1active.png'
                  : 'assets/icons/1.png',
              width: 28,
              height: 28,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1
                  ? 'assets/icons/2active.png'
                  : 'assets/icons/2.png',
              width: 28,
              height: 28,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2
                  ? 'assets/icons/3active.png'
                  : 'assets/icons/3.png',
              width: 28,
              height: 28,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3
                  ? 'assets/icons/4active.png'
                  : 'assets/icons/4.png',
              width: 28,
              height: 28,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
