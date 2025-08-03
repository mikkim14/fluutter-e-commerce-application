import 'package:flutter/material.dart';
import 'payment_verification_page.dart';

class QrCodePage extends StatelessWidget {
  final double amount;
  final String paymentMethod;
  final VoidCallback? onPaymentVerified;
  const QrCodePage({
    super.key,
    required this.amount,
    required this.paymentMethod,
    this.onPaymentVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          paymentMethod == 'GCash' ? 'G-Cash Payment' : 'Cash on Delivery',
        ),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                paymentMethod == 'GCash' ? 'Scan to Pay' : 'Scan to Confirm',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF01579B), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/qr_code_placeholder.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  // Always proceed to payment verification after callback
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentVerificationPage(
                        amount: amount,
                        paymentMethod: paymentMethod,
                        onPaymentComplete: onPaymentVerified,
                      ),
                    ),
                  );
                },
                child: Text('Verify Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
