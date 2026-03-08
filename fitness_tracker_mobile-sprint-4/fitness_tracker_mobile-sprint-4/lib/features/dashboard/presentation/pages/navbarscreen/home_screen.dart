import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Plans
              Text(
                "My plans",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: planCard(
                      title: "Lose Weight",
                      subtitle: "8 weeks",
                      image: "assets/btn_img1.png",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: planCard(
                      title: "Custom Workout",
                      subtitle: "Adapt to your goals",
                      image: "assets/btn_img2i.png",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),

              // Ready to be Chad
              Text(
                "Ready to be Chad!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Warm-up",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              // Popular Goals
              Text(
                "Popular Goals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  goalChip("Lose Weight", true),
                  goalChip("Build Muscle", false),
                  goalChip("Shape Body", false),
                ],
              ),

              SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    workoutTile(
                      title: "Burn 100 Calories",
                      subtitle: "9 min  •  14 exercises",
                    ),
                    workoutTile(
                      title:
                          "Belly Fat Burner High intensity interval Training (Beginner)",
                      subtitle: "14 min  •  16 exercises",
                    ),
                    workoutTile(
                      title:
                          "Belly Fat Burner High intensity interval Training (Intermediate)",
                      subtitle: "18 min  •  30 exercises",
                    ),
                    workoutTile(
                      title:
                          "Belly Fat Burner High intensity interval Training (Advanced)",
                      subtitle: "20 min  •  24 exercises",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget planCard({
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget goalChip(String text, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(text),
        backgroundColor: selected ? Colors.black : Colors.grey.shade300,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget workoutTile({
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
