import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/beforeLoginPages/first_screen.dart';
import 'package:fitness/pages/dashboardpages/ProfileFormPages.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _userData = doc.data();
          _isLoading = false;
        });
      }
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const FirstScreen()),
      (route) => false,
    );
  }

  void _showBottomSheet(String type) async {
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        if (type == "personal") {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _infoTile("Username", _userData?['username'] ?? 'N/A'),
                _infoTile("Email", _userData?['email'] ?? 'N/A'),
                _infoTile("Height", "${_userData?['height'] ?? '--'} cm"),
                _infoTile("Weight", "${_userData?['weight'] ?? '--'} kg"),
                _infoTile("Gender", _userData?['gender'] ?? 'N/A'),
              ],
            ),
          );
        } else if (type == "workout") {
          final today = DateTime.now();
          final docId =
              "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

          final workoutRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('workouts')
              .doc(docId)
              .collection('items')
              .orderBy('timestamp', descending: true);

          return StreamBuilder(
            stream: workoutRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final workouts = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  shrinkWrap: true,
                  children: workouts.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(Icons.fitness_center, color: Colors.purple),
                      title: Text(data['title'] ?? ''),
                      subtitle: Text(
                          "${data['duration']} min · ${data['calories']} cal"),
                    );
                  }).toList(),
                ),
              );
            },
          );
        } else if (type == "history") {
          final activityRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('activities') // Using 'activities' instead of 'logs'
              .orderBy('timestamp', descending: true);
          return StreamBuilder(
            stream: activityRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final activities = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  shrinkWrap: true,
                  children: activities.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final time = (data['timestamp'] as Timestamp).toDate();
                    return ListTile(
                      leading: Icon(Icons.check_circle,
                          color:
                              data['completed'] ? Colors.green : Colors.grey),
                      title: Text(data['title'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['description'] ?? ''),
                          SizedBox(height: 4),
                          Text(
                            timeago.format(data['timestamp'].toDate()),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: data['completed'] ?? false,
                        onChanged: (_) => toggleActivityStatus(
                            doc.reference, data['completed']),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        }

        return Center(child: Text("No data"));
      },
    );
  }

  Future<void> toggleActivityStatus(
      DocumentReference activityRef, bool currentStatus) async {
    try {
      await activityRef.update({'completed': !currentStatus});
    } catch (e) {
      debugPrint('Failed to update activity status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update activity.")),
      );
    }
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text("Profile",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFFF7C7C),
                        backgroundImage: FirebaseAuth
                                    .instance.currentUser?.photoURL !=
                                null
                            ? NetworkImage(
                                FirebaseAuth.instance.currentUser!.photoURL!)
                            : null,
                        child:
                            FirebaseAuth.instance.currentUser?.photoURL == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                      ),
                      title: Text(
                        _userData?['username'] ?? 'Hey_279',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        _userData?['email'] ?? 'No email',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7C7C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompleteProfilePage(
                                onComplete: () {},
                              ),
                            ),
                          );
                        },
                        child: const Text("Edit"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard(
                            "${_userData?['height'] ?? '--'}cm", "Height"),
                        _infoCard(
                            "${_userData?['weight'] ?? '--'}kg", "Weight"),
                        _infoCard("${_userData?['gender'] ?? '--'}", "Gender"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Section for triggering modals
                    ListTile(
                      leading: Icon(Icons.person_outline, color: Colors.green),
                      title: Text("Personal Data"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showBottomSheet("personal"),
                    ),
                    ListTile(
                      leading: Icon(Icons.emoji_events, color: Colors.orange),
                      title: Text("Workout"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showBottomSheet("workout"),
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.blue),
                      title: Text("Activity History"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showBottomSheet("history"),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7C7C),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _logout(context),
                      child: const Text("Logout"),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _infoCard(String value, String label) {
    return Expanded(
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFFF7C7C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
