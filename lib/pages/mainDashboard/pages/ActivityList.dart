import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityList extends StatefulWidget {
  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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

  Widget _buildActivityTile(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.pink[50],
          child: const Icon(
            Icons.local_drink,
            color: Colors.pinkAccent,
          ),
        ),
        title: Text(
          activity['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          timeago.format(activity['timestamp'] ?? DateTime.now()),
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: PopupMenuButton<String>(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Activity List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        return _buildActivityTile(_activities[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
