import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../models/product_catalog.dart';

class WriteReviewPage extends StatefulWidget {
  final Order order;
  const WriteReviewPage({super.key, required this.order});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0.0;

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      // Creating the review object
      final review = Review(
        userName:
            'User', // Replace this with the current session info or user ID
        productId: widget.order.id, // Reference to productId
        rating: _rating,
        comment: _reviewController.text,
        date: DateTime.now(),
      );

      // Add review to the product
      final product = ProductCatalog.allProducts.firstWhere(
        (p) => p.id == widget.order.id,
        orElse: () => throw Exception('Product not found'),
      );

      product.reviews.add(review);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Pop the review page after submission
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review for: ${widget.order.productName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rating (1-5):',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Slider(
                    value: _rating,
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: _rating.toStringAsFixed(1),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Review Comment:',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your review...',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write a comment.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 143, 87),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
