import 'package:flutter/material.dart';

class DatePlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with back arrow
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Recommended date plan!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Image directly below the banner, matching width
            Image.asset(
              'assets/icons/dateplan.png', // Replace with actual image
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Grid of date plan options
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjust aspect ratio
                ),
                itemCount: datePlans.length,
                itemBuilder: (context, index) {
                  final datePlan = datePlans[index];
                  return _buildDatePlanCard(
                    datePlan['imagePath']!,
                    datePlan['title']!,
                    datePlan['description']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePlanCard(String imagePath, String title, String description) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// List of date plans
final List<Map<String, String>> datePlans = [
  {
    'imagePath': 'assets/icons/angkorwat.png',
    'title': 'Angkor Wat',
    'description': 'A UNESCO World Heritage Site. It is good for couples to visit.',
  },
  {
    'imagePath': 'assets/icons/aquarium.png',
    'title': 'Aquarium',
    'description': 'A great place to see beautiful fish and marine life.see all kinds of fish!',
  },
  {
    'imagePath': 'assets/icons/cafe jrolong phnom.png',
    'title': 'Cafe Jrolong Pnhom',
    'description': 'A serene outdoor café with rustic bamboo architecture, lush greenery, and a peaceful garden setting under a bright blue sky.. Perfect for a date!',
  },
  {
    'imagePath': 'assets/icons/eden.png',
    'title': 'Eden',
    'description': 'A lively outdoor bar and restaurant with vibrant lighting, lush greenery, and a bustling crowd enjoying the night.it is a great place to hang out with partner and enjoy the nightlife.',
  
  },
  {
    'imagePath': 'assets/icons/movie.png',
    'title': 'Movie date',
    'description': 'movies are a great way to spend time together. Enjoy a movie with your partner!',
  },
  {
    'imagePath': 'assets/icons/keb viila.png',
    'title': 'Keb Villa',
    'description': 'A beautiful villa with a pool and a stunning view of the sunset. Perfect for a romantic getaway!',
  },
  {
    'imagePath': 'assets/icons/koh norea.png',
    'title': 'Koh Norea',
    'description': 'it is a great place to relax and enjoy the view of river with your partner and enjoy the sunset.',
  },
  {
    'imagePath': 'assets/icons/kirirom.png',
    'title': 'Kirirom national park',
    'description': 'A beautiful national park with stunning views and a variety of outdoor activities. Perfect for a day trip!',
  },
  {
    'imagePath': 'assets/icons/ktre ktrok.png',
    'title': 'ktre ktrok',
    'description': 'it is a old vibe cafe and restaurnt. Perfect for a romantic dinner!',
  },
  {
    'imagePath': 'assets/icons/pubstreet.png',
    'title': 'Pub street',
    'description': 'A lively street filled with bars, restaurants, and shops. Perfect for a night out!',
  },
];