import 'package:flutter/material.dart';
import 'HomeScreen.dart'; // Make sure to import your home screen

class SecondPaymentScreen extends StatelessWidget {
  final String companionName;
  final double totalPrice;
  final String meetingPlace;
  final String dateTime;

  const SecondPaymentScreen({
    super.key,
    required this.companionName,
    required this.totalPrice,
    required this.meetingPlace,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, 
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Complete Payment',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/payment.png',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Payment Summary",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Review your booking with $companionName",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Booking Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Booking Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF424242), // Equivalent to Colors.grey[800]
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.person_outline, "Companion", companionName),
                  _buildDetailRow(Icons.location_on_outlined, "Location", meetingPlace),
                  _buildDetailRow(Icons.calendar_today, "Date & Time", dateTime),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _buildPaymentRow("Service Fee", totalPrice),
                  const SizedBox(height: 8),
                  _buildPaymentRow("Total Amount", totalPrice, isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Promo Code
            const Text(
              "Promo Code",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter promo code",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildPaymentMethod(
                  icon: Icons.credit_card,
                  label: "Card",
                  color: const Color(0xFF6C5CE7),
                ),
                const SizedBox(width: 12),
                _buildPaymentMethod(
                  icon: Icons.account_balance,
                  label: "Bank",
                  color: const Color(0xFF00B894),
                ),
                const SizedBox(width: 12),
                _buildPaymentMethod(
                  icon: Icons.mobile_friendly,
                  label: "Mobile",
                  color: const Color(0xFFFD79A8),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Terms & Conditions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFF6C5CE7),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const Expanded(
                  child: Text(
                    "By proceeding, I agree to the Terms of Service and Privacy Policy",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _processPayment(context);
                },
                child: const Text(
                  "Confirm Payment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF6C5CE7)),
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      // Close loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Payment successful!"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      // Navigate to HomeScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    });
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.w700,
            color: isTotal ? const Color(0xFF6C5CE7) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}