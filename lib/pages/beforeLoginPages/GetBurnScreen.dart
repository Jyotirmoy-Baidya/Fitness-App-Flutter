import 'package:fitness/pages/beforeLoginPages/EatWellScreen.dart';
import 'package:flutter/material.dart';

class GetBurnScreen extends StatelessWidget {
  const GetBurnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top illustration with custom background
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              // height: MediaQuery.of(context).size.height * 0.50,
              child: Center(
                child: Image.asset(
                  'assets/images/runner.png', // Your image path here
                  width: double.infinity, // Set width to screen width

                  fit: BoxFit
                      .cover, // Or BoxFit.contain depending on your preference
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Text content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Get Burn",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Button
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle next or skip
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EatWellScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF7E86),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
