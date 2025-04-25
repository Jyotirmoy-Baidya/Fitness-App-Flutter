import 'package:flutter/material.dart';

class AccountSettingsContainer extends StatefulWidget {
  const AccountSettingsContainer({super.key});

  @override
  _AccountSettingsContainerState createState() =>
      _AccountSettingsContainerState();
}

class _AccountSettingsContainerState extends State<AccountSettingsContainer> {
  bool _isNotificationEnabled = true; // Initial state for the switch

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildAccountTile(Icons.person_outline, 'Personal Data'),
              _buildAccountTile(Icons.emoji_events_outlined, 'Achievement'),
              _buildAccountTile(Icons.history, 'Activity History'),
              _buildAccountTile(Icons.bar_chart, 'Workout Progress'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.notifications_none, color: Colors.pink),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pop-up Notification',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Switch(
                    value: _isNotificationEnabled, // Bind switch to the state
                    onChanged: (value) {
                      setState(() {
                        _isNotificationEnabled = value; // Update state
                      });
                    },
                    activeColor: Colors.pink,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
