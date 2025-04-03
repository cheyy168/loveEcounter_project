import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final String companionName;
  final String duration;
  final String meetingPlace;
  final List<String> optionalServices;
  final double totalPrice;
  final String phoneNumber;
  final String dateTime;

  const CheckoutScreen({
    super.key,
    required this.companionName,
    required this.duration,
    required this.meetingPlace,
    required this.optionalServices,
    required this.totalPrice,
    required this.phoneNumber,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple, semanticLabel: 'Back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Check Out',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xDFD453AF),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.description, color: Colors.blue, semanticLabel: 'Description Icon'),
                SizedBox(width: 10),
                Icon(Icons.calendar_today, color: Colors.grey, semanticLabel: 'Calendar Icon'),
              ],
            ),
            const SizedBox(height: 20),
            const Icon(Icons.touch_app, size: 80, color: Colors.purple, semanticLabel: 'Touch Icon'),
            const SizedBox(height: 20),
            const Text(
              'The Information about your companion',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_circle, size: 30, semanticLabel: 'Account Icon'),
                      const SizedBox(width: 10),
                      Text(
                        'Ms. $companionName',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.verified, color: Colors.blue, size: 20, semanticLabel: 'Verified Icon'),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Time: $dateTime'),
                  const SizedBox(height: 5),
                  Text('Location: $meetingPlace'),
                  const SizedBox(height: 5),
                  Text('Contact: $phoneNumber'),
                  const SizedBox(height: 5),
                  Text(
                    'Optional Services: ${optionalServices.isNotEmpty ? optionalServices.join(", ") : "No optional services selected"}',
                  ),
                  const SizedBox(height: 5),
                  Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xDFD453AF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Navigate to the next payment screen or perform payment logic
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Add functionality for contacting support
              },
              child: const Text(
                'Something went wrong or any concern please contact us here.',
                style: TextStyle(
                  color: Color.fromARGB(255, 94, 118, 217),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
"123"