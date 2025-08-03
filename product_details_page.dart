// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../models/product_catalog.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName; // Product name passed to the widget
  final double price;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  static final Set<String> _favorites =
      <String>{}; // Store favorite products' ids

  const ProductDetailsPage({
    super.key,
    required this.productName,
    required this.price,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = widget.isFavorite;
  }

  // Handle favorite toggling
  void _handleFavorite() {
    setState(() {
      _favorite = !_favorite;
      final product = ProductCatalog.allProducts.firstWhere(
        (p) => p.name == widget.productName,
      );
      if (_favorite) {
        // Adding product ID to favorites (use product.id as the key)
        ProductDetailsPage._favorites.add(product.id.toString());
      } else {
        // Removing product ID from favorites
        ProductDetailsPage._favorites.remove(product.id.toString());
      }
    });
    widget.onToggleFavorite();
  }

  // Submit the review
  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) {
        double _rating = 0.0;
        TextEditingController _reviewController = TextEditingController();
        return AlertDialog(
          title: const Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rating (1-5):'),
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
              const Text('Review Comment:'),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final product = ProductCatalog.allProducts.firstWhere(
                  (p) => p.name == widget.productName,
                );
                final review = Review(
                  userName: 'User', // Replace with session info
                  productId: product.id, // Use product.id as ID (int)
                  rating: _rating,
                  comment: _reviewController.text,
                  date: DateTime.now(),
                );
                product.reviews.add(review);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review submitted successfully!'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Submit Review'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ProductCatalog.allProducts.firstWhere(
      (p) => p.name == widget.productName,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          IconButton(
            icon: FaIcon(
              _favorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
              color: _favorite ? Colors.red : Colors.white,
            ),
            onPressed: _handleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FaIcon(
                FontAwesomeIcons.couch,
                size: 120,
                color: const Color(0xFF01579B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.productName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Php ${widget.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'High-quality furniture to elevate your living space. '
              'Crafted with precision and comfort in mind.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reviews:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Display reviews for this product
            Expanded(
              child: ListView.builder(
                itemCount: product.reviews.length,
                itemBuilder: (context, index) {
                  final review = product.reviews[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              for (int i = 0; i < review.rating; i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review.comment),
                          const SizedBox(height: 4),
                          Text(
                            review.date.toLocal().toString().split(' ')[0],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: FaIcon(
                    _favorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: _favorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: _handleFavorite,
                  tooltip: _favorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                ),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01579B),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        int quantity = 1;
                        String paymentMethod = 'Cash on Delivery';
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                final double shippingFee = 200;
                                final double total =
                                    (widget.price * quantity) + shippingFee;
                                return AlertDialog(
                                  title: const Text('Proceed to Payment'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.couch,
                                            color: Color(0xFF01579B),
                                            size: 32,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              widget.productName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: quantity > 1
                                                ? () =>
                                                      setState(() => quantity--)
                                                : null,
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () =>
                                                setState(() => quantity++),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Item Price: Php ${widget.price.toStringAsFixed(2)}',
                                      ),
                                      Text(
                                        'Shipping Fee: Php ${shippingFee.toStringAsFixed(2)}',
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Total: Php ${total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      DropdownButton<String>(
                                        value: paymentMethod,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'Cash on Delivery',
                                            child: Text('Cash on Delivery'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Online Payment',
                                            child: Text('Online Payment'),
                                          ),
                                        ],
                                        onChanged: (val) => setState(
                                          () => paymentMethod = val!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final orderId = Order.orders.length + 1;
                                        Order.addOrder(
                                          id: orderId,
                                          userId: 1, // Demo user
                                          productName: widget.productName,
                                          quantity: quantity,
                                          itemPrice: widget.price,
                                          paymentMethod: paymentMethod,
                                        );
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 32,
                                                    horizontal: 24,
                                                  ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 64,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const Text(
                                                    'Order Successful',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Confirm Order'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
