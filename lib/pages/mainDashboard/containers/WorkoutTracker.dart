import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkoutTracker extends StatefulWidget {
  @override
  _WorkoutTrackerState createState() => _WorkoutTrackerState();
}

class _WorkoutTrackerState extends State<WorkoutTracker> {
  User? _user;
  late String todayId;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;

    final today = DateTime.now();
    todayId =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  }

  Future<void> _addWorkoutDialog() async {
    String title = '';
    int duration = 0;
    int calories = 0;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Workout'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (val) => title = val,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Duration (min)'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => duration = int.tryParse(val) ?? 0,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Calories Burned'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => calories = int.tryParse(val) ?? 0,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (title.isNotEmpty && _user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.uid)
                      .collection('workouts')
                      .doc(todayId)
                      .collection('items')
                      .add({
                    'title': title,
                    'duration': duration,
                    'calories': calories,
                    'completed': false,
                    'timestamp': Timestamp.now(),
                  });
                }
                Navigator.of(ctx).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleComplete(DocumentReference ref, bool current) async {
    await ref.update({'completed': !current});
  }

  Future<void> _deleteWorkout(DocumentReference ref) async {
    await ref.delete();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return Center(child: Text("Not logged in"));

    final workoutRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('workouts')
        .doc(todayId)
        .collection('items')
        .orderBy('timestamp', descending: true);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Workout Tracker",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.purple),
                onPressed: _addWorkoutDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: workoutRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final workouts = snapshot.data!.docs;

              if (workouts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text("No workouts added yet."),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: workouts.length,
                itemBuilder: (ctx, i) {
                  final doc = workouts[i];
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.fitness_center, color: Colors.purple),
                      title: Text(data['title'] ?? ''),
                      subtitle: Text(
                          "${data['duration']} min · ${data['calories']} cal"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: data['completed'] ?? false,
                            onChanged: (_) => _toggleComplete(
                                doc.reference, data['completed']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteWorkout(doc.reference),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
