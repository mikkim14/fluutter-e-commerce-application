import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user_session.dart';
import '../models/product_catalog.dart';
import 'order_management.dart';

class PaymentVerificationPage extends StatelessWidget {
  final double amount;
  final String paymentMethod;
  final VoidCallback? onPaymentComplete;

  const PaymentVerificationPage({
    super.key,
    required this.amount,
    required this.paymentMethod,
    this.onPaymentComplete,
  });

  String get initials => 'SS'; // Initials for Sesno Sash

  // Helper to find product by name
  Product? _findProductByName(String name) {
    try {
      return ProductCatalog.allProducts.firstWhere((p) => p.name == name);
    } catch (_) {
      return null;
    }
  }

  // Simulate a payment processing method
  Future<bool> processPayment() async {
    await Future.delayed(
      const Duration(seconds: 3),
    ); // Simulate a network delay
    return true; // Simulate a successful payment
  }

  @override
  Widget build(BuildContext context) {
    String payLabel = paymentMethod == 'Cash on Delivery'
        ? '20% Down Payment'
        : 'Amount Due';

    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SESNO SASH',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'PAY WITH',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          paymentMethod,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'php',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF1565C0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      paymentMethod == 'Cash on Delivery'
                          ? 'YOU ARE ABOUT TO PAY (20% Down Payment)'
                          : 'YOU ARE ABOUT TO PAY',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(payLabel, style: const TextStyle(fontSize: 16)),
                        Text(
                          'php ${amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount', style: TextStyle(fontSize: 16)),
                        Text(
                          'No available voucher',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payLabel == '20% Down Payment'
                              ? 'Total Down Payment'
                              : 'Total Amount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'php ${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Please review to ensure that the details are correct before you proceed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () async {
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          // 1. Add order(s) for all cart items
                          final itemCounts = <String, int>{};
                          for (final item in Cart.items) {
                            itemCounts[item] = (itemCounts[item] ?? 0) + 1;
                          }
                          final user = UserSession.users.firstWhere(
                            (u) => u.email == UserSession.email,
                            orElse: () => UserSession.users.first,
                          );
                          for (final name in itemCounts.keys) {
                            final product = _findProductByName(name);
                            if (product != null) {
                              final orderId =
                                  Order.orders.length +
                                  1; // Simple unique ID generation
                              Order.addOrder(
                                id: orderId, // Use the generated ID
                                userId: user.id ?? 0,
                                productName: name,
                                quantity: itemCounts[name]!,
                                itemPrice: product.price,
                                paymentMethod: paymentMethod,
                              );
                            }
                          }

                          // 2. Clear the cart
                          Cart.clear();

                          // 3. Simulate payment processing
                          bool paymentSuccess = await processPayment();

                          // Dismiss the loading indicator
                          Navigator.pop(context);

                          if (paymentSuccess) {
                            // 4. Show success dialog and navigate to Homepage
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Payment Confirmed'),
                                content: const Text(
                                  'Your payment has been successfully processed.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      // Navigate to Homepage after closing dialog
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const OrderManagement(),
                                        ),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Handle payment failure
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Payment Failed'),
                                content: const Text(
                                  'There was an issue with your payment.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (onPaymentComplete != null) {
                            onPaymentComplete!();
                          }
                        },
                        child: Text('Pay php ${amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
