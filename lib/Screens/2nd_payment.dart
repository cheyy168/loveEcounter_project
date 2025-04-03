import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckoutScreen(),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Check Out",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xDFD453AF),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 10),
                Icon(Icons.check_circle, color: Colors.blue),
              ],
            ),
            SizedBox(height: 20),
            Image.asset(
              'images/payment.png', 
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              "Please fill the information about payment",
              style: TextStyle(color: Colors.pink, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Booking ID", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("A-7BHI9HDTSBK0E", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  paymentRow("Service Fee:", "\$60"),
                  paymentRow("Tip:", "\$10"),
                  Divider(),
                  paymentRow("Total Amount:", "\$70"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Promo Code Field:"),
                  SizedBox(height: 10),
                  Text("Payment Methods Available"),
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.blue),
                      SizedBox(width: 10),
                      Icon(Icons.payment, color: Colors.red),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Text("Terms & Conditions"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xDFD453AF),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text("Finish", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 5    ),
            Text(
              "Something went wrong or any concern please contact us here.",
              style: TextStyle(color: Colors.pink),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
      ),
    );
  }
}
