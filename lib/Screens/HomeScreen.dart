import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'ProfileScreen.dart';
import 'login_screen.dart';
import 'how_to_use.dart';
import 'EmployeeDetail.dart';
import 'Pricelist.dart';
import 'dateplan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _bookings = [];
  int _unreadBookingsCount = 0;
  bool _loadingBookings = true;
  String _userName = 'Guest';
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBookings();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _userName = doc.data()?['full_name'] ?? 
                       user.displayName ?? 
                       user.email?.split('@')[0] ?? 
                       'User';
            _loadingUser = false;
          });
        }
      }
    } catch (e) {
      setState(() => _loadingUser = false);
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _loadBookings() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('bookings')
            .where('user_id', isEqualTo: user.uid)
            .orderBy('created_at', descending: true)
            .get();

        setState(() {
          _bookings = snapshot.docs.map((doc) => doc.data()).toList();
          _unreadBookingsCount = _bookings.length;
          _loadingBookings = false;
        });
      }
    } catch (e) {
      setState(() => _loadingBookings = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bookings: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = _auth.currentUser?.uid ?? 'UNKNOWN_USER';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Row(
          children: [
            Text(
              _loadingUser ? 'Loading...' : 'Hi, $_userName!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          _buildNotificationIcon(),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(uid: uid),
              ),
            ).then((_) => _refreshData()),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showLogoutDialog,
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
              'Why We Are Cambodia\'s No.1 Dating App',
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

  Future<void> _refreshData() async {
    await _loadUserData();
    await _loadBookings();
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: _showBookingHistory,
        ),
        if (_unreadBookingsCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Text(
                _unreadBookingsCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showBookingHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Booking History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_loadingBookings)
                const Center(child: CircularProgressIndicator())
              else if (_bookings.isEmpty)
                const Center(
                  child: Text(
                    'No bookings yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: _bookings.length,
                    separatorBuilder: (context, index) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return _buildBookingCard(booking);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['companion_name'] ?? 'Unknown Companion',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking['status']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking['status']?.toString().toUpperCase() ?? 'UNKNOWN',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildBookingDetail(Icons.calendar_today, booking['date_time']),
            _buildBookingDetail(Icons.access_time, booking['duration']),
            _buildBookingDetail(Icons.location_pin, booking['meeting_place']),
            if (booking['optional_services'] != null &&
                (booking['optional_services'] as List).isNotEmpty)
              _buildBookingDetail(
                Icons.add_circle_outline,
                'Extras: ${(booking['optional_services'] as List).join(', ')}',
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${booking['total_amount']?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDate(booking['created_at']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetail(IconData icon, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.pink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not specified',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
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
        "description": "Enjoy premium services with a warm and professional touch!",
      },
      {
        "icon": Icons.account_balance_wallet,
        "title": "Clear Accounting! No Tip Required!",
        "description": "No hidden fees! Tipping is optional.",
      },
      {
        "icon": Icons.verified,
        "title": "Operated by a Reliable Organization",
        "description": "We operate from a registered address with professional support.",
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
                top: Radius.circular(12)),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
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