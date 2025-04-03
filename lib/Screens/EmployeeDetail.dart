import 'package:flutter/material.dart';
import 'form.dart'; // Make sure to import the form.dart file

class EmployeeDetail extends StatelessWidget {
  final String name;
  final String age;
  final String location;
  final String description;
  final String imagePath;

  const EmployeeDetail({
    super.key,
    required this.name,
    required this.age,
    required this.location,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '$location  $name ($age)',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Center(
                child: Text(
                  'Her Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Her',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hobbies & Interests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _getHobbies(name),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Languages',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _getLanguages(name),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationForm(name: name),
                          ),
                        );
                      },
                      child: const Text(
                        'Reservation Form',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHobbies(String name) {
    switch (name) {
      case "Jennie Kim":
        return "• Loves singing and dancing 🎤\n"
            "• Enjoys exploring new restaurants 🍴\n"
            "• Passionate about fashion and styling 👗";
      case "Sakura Tanaka":
        return "• Enjoys painting and sketching 🎨\n"
            "• Loves hiking and exploring nature 🌿\n"
            "• Passionate about Japanese tea ceremonies 🍵";
      case "Lee Minji":
        return "• Loves photography and capturing moments 📸\n"
            "• Enjoys reading novels 📚\n"
            "• Passionate about interior design 🏡";
      case "Park Yuna":
        return "• Enjoys playing the piano 🎹\n"
            "• Loves gardening and growing flowers 🌸\n"
            "• Passionate about baking and creating desserts 🍰";
      default:
        return "• Enjoys various hobbies and activities.";
    }
  }

  String _getLanguages(String name) {
    switch (name) {
      case "Jennie Kim":
        return "• Fluent in Korean and English 🌏\n"
            "• Learning Japanese ✍️";
      case "Sakura Tanaka":
        return "• Fluent in Japanese and English 🌏\n"
            "• Learning Khmer ✍️";
      case "Lee Minji":
        return "• Fluent in Korean, English, and French 🌏";
      case "Park Yuna":
        return "• Fluent in Khmer and English 🌏\n"
            "• Learning Chinese ✍️";
      default:
        return "• Fluent in multiple languages.";
    }
  }
}