import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeScreen.dart';

class InformationUserScreen extends StatefulWidget {
  const InformationUserScreen({super.key});

  @override
  _InformationUserScreenState createState() => _InformationUserScreenState();
}

class _InformationUserScreenState extends State<InformationUserScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitInfo() async {
    final String fullName = _fullNameController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your full name")),
      );
      return;
    }

    if (phoneNumber.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'full_name': fullName,
          'phone_number': phoneNumber,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink, Colors.purple],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/logo-.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                      hintText: 'Enter Full Name',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone, color: Colors.white),
                      hintText: 'Enter Phone Number',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ),
                          ),
                          onPressed: _submitInfo,
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}