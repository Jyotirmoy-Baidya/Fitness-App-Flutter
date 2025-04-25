import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityTrackerPage extends StatefulWidget {
  @override
  _ActivityTrackerPageState createState() => _ActivityTrackerPageState();
}

class _ActivityTrackerPageState extends State<ActivityTrackerPage> {
  int waterIntake = 0;
  int footSteps = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadTargets();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('activities')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _activities = docs.docs
            .map((doc) => {
                  'id': doc.id,
                  'title': doc['title'],
                  'description': doc['description'],
                  'timestamp': doc['timestamp']?.toDate(),
                })
            .toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteActivity(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('activities')
          .doc(id)
          .delete();

      _loadActivities();
    }
  }

  Future<void> _loadTargets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('targets')
          .doc('today')
          .get();
      if (doc.exists) {
        setState(() {
          waterIntake = doc.data()?['waterIntake'] ?? 0;
          footSteps = doc.data()?['footSteps'] ?? 0;
        });
      }
    }
  }

  Future<void> _updateTarget(String field, int value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('targets')
          .doc('today');

      await ref.set({field: value}, SetOptions(merge: true));
      _loadTargets();
    }
  }

  void _showUpdateTargetDialog(
      String title, int currentValue, Function(int) onUpdate) {
    final TextEditingController controller =
        TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update $title Target'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Enter new $title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                int value = int.tryParse(controller.text) ?? 0;
                onUpdate(value);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF37C7C),
            ),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard(
      String title, String value, String imagePath, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: 24),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(200, 242, 143, 143)),
                ),
                SizedBox(height: 4),
                Text(title, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Activity Tracker', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Icon(Icons.more_vert, color: Colors.black),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.fromLTRB(24, 10, 24, 10),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(70, 242, 143, 143),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: Row(
                      children: [
                        Text(
                          "Today Target",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _showUpdateTargetDialog("Water Intake", waterIntake,
                                (value) {
                              setState(() => waterIntake = value);
                              _updateTarget('waterIntake', value);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF37C7C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(6),
                            minimumSize: Size(30, 30),
                            elevation: 0,
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTargetCard(
                        "Water Intake",
                        "${waterIntake}L",
                        "assets/activity/water.png",
                        () => _showUpdateTargetDialog(
                            "Water Intake", waterIntake, (value) {
                          setState(() => waterIntake = value);
                          _updateTarget('waterIntake', value);
                        }),
                      ),
                      _buildTargetCard(
                        "Foot Steps",
                        "$footSteps Steps",
                        "assets/activity/steps.png",
                        () => _showUpdateTargetDialog("Foot Steps", footSteps,
                            (value) {
                          setState(() => footSteps = value);
                          _updateTarget('footSteps', value);
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Activity Progress Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Activity Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text("Weekly", style: TextStyle(color: Colors.white)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 160,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  ),
              child: Center(
                child: Image.asset(
                  'assets/activity/graph.png',
                  width: double.infinity, // makes the image take up full width
                  height:
                      double.infinity, // makes the image take up full height
                  fit: BoxFit
                      .cover, // scales and crops the image to fill the container
                ),
              ),
            ),

            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Latest Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text("See more", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Activity List
            Container(
              height: 300, // or use MediaQuery for dynamic height
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityTile(_activities[index]);
                },
              ),
            ) // ActivityScreenTest()
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(
            activity['title'].contains('Drinking')
                ? 'assets/activity/drinking.png'
                : 'assets/activity/eating.png',
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  timeago.format(activity['timestamp'] ?? DateTime.now()),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (String value) {
              if (value == 'delete') {
                _deleteActivity(activity['id']);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
