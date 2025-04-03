import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> _userData;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _userData = _firestoreService.getUserProfile(widget.uid); // Updated method name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data available'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(userData),
                const SizedBox(height: 20),
                _buildProfileSection('Personal Information', [
                  _buildProfileItem(Icons.person, 'Full Name', userData['full_name']),
                  _buildProfileItem(Icons.email, 'Email', userData['email']),
                  _buildProfileItem(Icons.phone, 'Phone', userData['phone_number']),
                ]),
                const SizedBox(height: 20),
                _buildProfileSection('Account Details', [
                  _buildProfileItem(Icons.calendar_today, 'Member Since', 
                      _formatDate(userData['created_at'])),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.pink[100],
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userData['full_name'] ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            userData['email'] ?? 'No Email',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value?.toString() ?? 'Not specified',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditProfileDialog(BuildContext context) async {
    final userData = await _userData;
    final data = userData.data() as Map<String, dynamic>;

    final TextEditingController nameController = 
        TextEditingController(text: data['full_name']);
    final TextEditingController phoneController = 
        TextEditingController(text: data['phone_number'] ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _firestoreService.updateUserProfile(
                    uid: widget.uid,
                    data: {
                      'full_name': nameController.text,
                      'phone_number': phoneController.text,
                    },
                  );
                  setState(() {
                    _userData = _firestoreService.getUserProfile(widget.uid);
                  });
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating profile: $e')),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}