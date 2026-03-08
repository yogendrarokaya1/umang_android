import 'package:fitness_tracker/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (value) {
          setState(() {
            _index = value;
          });
        },
        children: [
          buildPage(
            image: "assets/on1.png",
            title1: "Hello,",
            title2: "Welcome to the journey to your dream body",
            title3: "Your strongest self starts here",
            subtitle: "Consistency creates results. Let’s begin.",
          ),
          buildPage(
            image: "assets/on1.png",
            title1: "Track Workouts",
            title2: "Keep an eye on your daily activity",
            title3: "Improve your performance",
            subtitle: "Grow stronger every day.",
          ),
          buildPage(
            image: "assets/on1.png",
            title1: "Stay Motivated",
            title2: "Build habits",
            title3: "Achieve your goals",
            subtitle: "Your fitness journey starts now.",
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          onPressed: () {
            if (_index < 2) {
              _controller.nextPage(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },

          child: Text(
            _index == 2 ? "Get Started" : "Next",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title1,
    required String title2,
    required String title3,
    required String subtitle,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 430,
            width: double.infinity,
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title1,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(title2,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(title3,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
