import 'package:fitness/pages/dashboardpages/WelcomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileFormAfterRegister extends StatefulWidget {
  final VoidCallback onComplete;

  const ProfileFormAfterRegister({super.key, required this.onComplete});

  @override
  _ProfileFormAfterRegisterState createState() =>
      _ProfileFormAfterRegisterState();
}

class _ProfileFormAfterRegisterState extends State<ProfileFormAfterRegister> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _gender;
  DateTime? _dob;
  String? _weight;
  String? _height;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _username = data['username'];
          _gender = data['gender'];
          _dob = DateTime.tryParse(data['date_of_birth'] ?? '');
          _weight = data['weight']?.toString();
          _height = data['height']?.toString();

          weightController.text = _weight ?? '';
          heightController.text = _height ?? '';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() == true &&
        _gender != null &&
        _dob != null &&
        _username != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _username,
          'email': user.email,
          'gender': _gender,
          'date_of_birth': _dob!.toIso8601String(),
          'weight': _weight,
          'height': _height,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );

        widget.onComplete(); // Notify parent to refresh state

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomePage(
                    userName: _username!,
                  )),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/fitness-lady.png', height: 200),
                SizedBox(height: 20),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        "assets/profileicons/profile.png",
                        "Your username",
                        usernameController,
                        onChanged: (value) => _username = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDOB(),
                SizedBox(height: 16),
                _buildDropdown(),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        "assets/profileicons/weight.png",
                        "Your Weight",
                        weightController,
                        onChanged: (value) => _weight = value,
                      ),
                    ),
                    SizedBox(width: 8),
                    _unitTag("KG"),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        "assets/profileicons/height.png",
                        "Your Height",
                        heightController,
                        onChanged: (value) => _height = value,
                      ),
                    ),
                    SizedBox(width: 8),
                    _unitTag("CM"),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF7676), Color(0xFFFFA8A8)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: _inputDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Image.asset('assets/profileicons/profile.png', height: 24),
              SizedBox(width: 12),
              Text("Choose Gender"),
            ],
          ),
          value: _gender,
          onChanged: (value) => setState(() => _gender = value),
          items: ['Male', 'Female', 'Other'].map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDOB() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _dob ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _dob = picked);
      },
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: _inputDecoration(),
        child: Row(
          children: [
            Image.asset('assets/profileicons/calender.png', height: 24),
            SizedBox(width: 12),
            Text(
              _dob == null
                  ? "Date of Birth"
                  : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String iconPath, String hint, TextEditingController controller,
      {required Function(String) onChanged}) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: _inputDecoration(),
      child: Row(
        children: [
          Image.asset(iconPath, height: 24),
          SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: hint == "Your username"
                  ? TextInputType.text
                  : TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _inputDecoration() => BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      );

  Widget _unitTag(String unit) {
    return Container(
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFFF8C8C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(unit,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
