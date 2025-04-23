import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/beforeLoginPages/first_screen.dart';
import 'package:fitness/pages/dashboardpages/ProfileFormPages.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF7C7C),
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFFFF7C7C),
                      backgroundImage:
                          FirebaseAuth.instance.currentUser?.photoURL != null
                              ? NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!)
                              : null,
                      child: FirebaseAuth.instance.currentUser?.photoURL == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      _userData?['name'] ?? 'Hey_279',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      _userData?['email'] ?? 'No program',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF7C7C),
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
                                  )),
                        );
                      },
                      child: const Text("Edit"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard(
                            "${_userData?['height'] ?? '--'}cm", "Height"),
                        _infoCard(
                            "${_userData?['weight'] ?? '--'}kg", "Weight"),
                        _infoCard("${_userData?['gender'] ?? '--'}", "Gender"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF7C7C),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _logout(context),
                      child: const Text("Logout"),
                    ),
                  )
                ],
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
            )
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
