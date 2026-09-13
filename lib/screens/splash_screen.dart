import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ডার্ক ব্যাকগ্রাউন্ড
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(), // লোগোকে মাঝখানে রাখার জন্য

            // DNews লোগো ডিজাইন (আইকন এবং টেক্সট)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1), // হালকা নীল ব্যাকগ্রাউন্ড
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.language, // গ্লোবাল নিউজ আইকন
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'D News',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2, // অক্ষরের মাঝে হালকা গ্যাপ
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Daily Dose of Global News',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(), // বাটনটিকে নিচে নামানোর জন্য

            // হাইলাইট করা Continue বাটন
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 55, // বাটনের উচ্চতা
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // নীল রঙের বাটন
                    foregroundColor: Colors.white, // সাদা লেখা
                    elevation: 10, // শ্যাডো
                    shadowColor: Colors.blueAccent.withValues(alpha: 0.5), // বাটনের নিচে গ্লোয়িং ইফেক্ট
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // গোল কর্নার
                    ),
                  ),
                  onPressed: () {
                    // বাটনে ক্লিক করলে HomeScreen এ যাবে
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 22), // ডানদিকের তীর চিহ্ন
                    ],
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