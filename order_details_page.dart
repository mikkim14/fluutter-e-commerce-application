import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product_catalog.dart';
import '../models/product.dart';
import 'write_review_page.dart'; // Import WriteReviewPage

class OrderDetailsPage extends StatelessWidget {
  final Order order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final product = ProductCatalog.allProducts.firstWhere(
      (p) => p.name == order.productName,
      orElse: () => Product(
        id: 0,
        name: order.productName,
        description: '',
        price: order.itemPrice,
        stockQuantity: 0,
      ),
    );

    final double shippingFee = 200;
    final double downPayment =
        (order.itemPrice * 0.2) * order.quantity + shippingFee;
    final double total = order.itemPrice * order.quantity + shippingFee;
    final double balanceDue = total - downPayment;
    final double amountPaid = downPayment + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio:
                      1, // This is a placeholder for when you know the aspect ratio of the image
                  child: Image.asset(
                    'assets/images/${product.id}.jpg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Product: ${order.productName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: ${order.quantity}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Payment Method: ${order.paymentMethod}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Order Date: ${order.orderDate}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Shipping Fee: Php ${shippingFee.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Amount: Php ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (order.paymentMethod == 'Cash on Delivery') ...[
              const SizedBox(height: 8),
              Text(
                'Down Payment: Php ${downPayment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount Paid: Php ${amountPaid.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 8),
              Text(
                'Balance Due: Php ${balanceDue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
            if (order.status == 'Cancelled' && order.cancelReason != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Cancelled Reason: ${order.cancelReason}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Receipt'),
                    content: const Text('Have you received your item?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WriteReviewPage(order: order),
                            ),
                          );
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Order Received'),
            ),
          ],
        ),
      ),
    );
  }
}
