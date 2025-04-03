import 'package:flutter/material.dart';


class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Text(
                    "Love Encounter",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "How to use ?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "We have various types of girlfriends in our store. Not only her appearance, "
              "but also her individual personality and occupation (worker, student, etc...) "
              "and our staff can find a girlfriend that suits you. Some of my girlfriends are "
              "quick to contact me, some of them are late, and some of them are working hard on their blog. "
              "Only girls who meet our standards can work as rental girlfriends.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(8.0),
              child: const Center(
                child: Text(
                  "You can send it directly to her via LINE or email!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/icons/how_1.png', // Replace with your image asset
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            const Text(
              "Send LINE or Mail to your favorite girlfriend. You can also send it to multiple girlfriends!\n\n"
              "Once the girl has checked her email, you will receive an email from Gmail.\n\n"
              "If you receive it on your mobile phone, please cancel your e-mail rejection designation! "
              "You can also send trial emails to multiple girlfriends you like.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
