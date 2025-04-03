import 'package:flutter/material.dart';
import 'ProfileScreen.dart'; // Import the ProfileScreen
import 'login_screen.dart'; // Import the login screen
import 'how_to_use.dart';
import 'EmployeeDetail.dart';
import 'Pricelist.dart';
import 'dateplan.dart'; // Import the DatePlanScreen
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'Guest';
    final String displayName = userName.split('@')[0];
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER'; // Fetch the UID from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Row(
          children: [
            Text(
              'Hi, $displayName!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Navigate to ProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(uid: uid), // Pass UID to ProfileScreen
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/icons/image.png', fit: BoxFit.cover),
            const SizedBox(height: 20),
            _buildNavigationButtons(context),
            const SizedBox(height: 20),
            const Text(
              'Why We Are Cambodia’s No.1 Dating App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildFeatureSection(),
            _buildAreaSection("Our State Employees"),
            _buildProfileGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    List<Map<String, dynamic>> navItems = [
      {'label': 'HOME', 'screen': const HomeScreen()},
      {'label': 'Utilization', 'screen': const HowToUsePage()},
      {'label': 'Charge', 'screen': const Pricelist()},
      {'label': 'Date PLAN', 'screen': DatePlanScreen()},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navItems.map((item) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['screen']),
              );
            },
            child: Text(item['label']),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureSection() {
    List<Map<String, dynamic>> features = [
      {
        "icon": Icons.favorite,
        "title": "We Offer Hospitality!",
        "description":
            "Enjoy premium services with a warm and professional touch!",
      },
      {
        "icon": Icons.account_balance_wallet,
        "title": "Clear Accounting! No Tip Required!",
        "description": "No hidden fees! Tipping is optional.",
      },
      {
        "icon": Icons.verified,
        "title": "Operated by a Reliable Organization",
        "description":
            "We operate from a registered address with professional support.",
      },
      {
        "icon": Icons.check_circle,
        "title": "All Members Are Verified!",
        "description": "All participants go through a screening process.",
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: features.map((feature) {
          return _buildFeatureCard(
            feature["icon"],
            feature["title"],
            feature["description"],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildAreaSection(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(8),
      color: Colors.pink.shade700,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileGrid(BuildContext context) {
    List<Map<String, String>> profiles = [
      {
        "name": "Jennie Kim",
        "age": "26",
        "location": "Phnom Penh",
        "description": "Slender beauty with a lively personality!",
        "imagePath": "assets/icons/jennie.jpg",
      },
      {
        "name": "Sakura Tanaka",
        "age": "24",
        "location": "Phnom Penh",
        "description": "Charming and intelligent with a bright smile!",
        "imagePath": "assets/icons/model2.jpg",
      },
      {
        "name": "Lee Minji",
        "age": "27",
        "location": "Phnom Penh",
        "description": "Confident, elegant, and adventurous!",
        "imagePath": "assets/icons/model3.jpg",
      },
      {
        "name": "Park Yuna",
        "age": "25",
        "location": "Phnom Penh",
        "description": "Fun-loving and passionate about art!",
        "imagePath": "assets/icons/model4.jpg",
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return _buildProfileCard(
            context,
            profile["name"]!,
            profile["age"]!,
            profile["location"]!,
            profile["description"]!,
            profile["imagePath"]!,
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    String name,
    String age,
    String location,
    String description,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetail(
              name: name,
              age: age,
              location: location,
              description: description,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 120,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "$name, $age",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  Text(
                    "Location: $location",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show logout dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
