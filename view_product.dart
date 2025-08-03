import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/favorites.dart';
import '../models/cart.dart';
import 'qr_code_page.dart';
import '../models/review.dart';

class ViewProductPage extends StatefulWidget {
  final Product product;
  final Map<int, double> productRatings;
  final Map<int, List<Review>> productReviews;

  const ViewProductPage({
    super.key,
    required this.product,
    required this.productRatings,
    required this.productReviews,
  });

  @override
  _ViewProductPageState createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    // Initialize favorite state
    isFavorite = Favorites.isFavorite(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final reviews = widget.productReviews[widget.product.id] ?? [];
    final rating = widget.productRatings[widget.product.id] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return AspectRatio(
                        aspectRatio: 1.5, // Default aspect ratio, can be tuned
                        child: Image.asset(
                          'assets/images/${widget.product.id}.jpg',
                          fit: BoxFit.contain, // Show whole image without crop
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01579B),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    tooltip: isFavorite
                        ? 'Remove from Favorites'
                        : 'Add to Favorites',
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          Favorites.remove(widget.product);
                        } else {
                          Favorites.add(widget.product);
                        }
                        isFavorite = !isFavorite; // Toggle favorite state
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Added to Favorites'
                                : 'Removed from Favorites',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Php ${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stock: ${widget.product.stockQuantity}',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01579B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStarRating(rating),
                  const SizedBox(width: 8),
                  Text(
                    '(${reviews.length} reviews)',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              reviews.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No reviews yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be the first to review this product!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: reviews.map((review) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  _buildStarRating(review.rating),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(review.comment),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(review.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 24),
              // Action Buttons for Add to Cart and Buy Now
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01579B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Add to Cart functionality
                        Cart.add(widget.product.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.name} has been added to your cart.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Proceed to Payment functionality
                        _showPaymentDetailsDialog(context, widget.product);
                      },
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index == rating.floor() && rating % 1 > 0) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
        }
      }),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Function to show payment details dialog
  void _showPaymentDetailsDialog(BuildContext context, Product product) {
    double shippingFee = 200;
    int quantity = 1; // Initial quantity

    // Calculate down payment for Cash on Delivery (20% of the product price * quantity)
    double downPayment = product.price * 0.2 * quantity;
    double merchandiseSubtotal =
        product.price * quantity; // Subtotal of the product cost
    double totalAmount =
        merchandiseSubtotal + shippingFee; // Total including shipping fee

    String selectedPaymentMethod = 'Cash on Delivery'; // Default is COD

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Payment Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Summary Section with Image
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product: ${product.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Image.asset(
                            'assets/images/${product.id}.jpg', // Product image path
                            width: double.infinity,
                            height: 200, // Adjust the image size as necessary
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quantity: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price per item: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Php ${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Merchandise Subtotal (Real-Time Calculation)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Merchandise Subtotal: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Php ${merchandiseSubtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Shipping Fee
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shipping Fee: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Php ${shippingFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Conditional Display for Down Payment or Total Amount
                    if (selectedPaymentMethod == 'Cash on Delivery') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Down Payment (20%): ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Php ${downPayment.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Total Payment Calculation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Payment: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Php ${(downPayment + shippingFee).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 49, 153, 39),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Balance Due Calculation (Real-Time)
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align text and value to the edges
                        children: [
                          const Text(
                            'Balance Due:',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Php ${(() {
                              double balanceDue = totalAmount - downPayment - shippingFee;
                              return balanceDue.toStringAsFixed(2);
                            })()}',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // G-Cash, show the total amount only
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Php ${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Payment Method:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;

                          // Recalculate the amount when payment method changes
                          if (selectedPaymentMethod == 'Cash on Delivery') {
                            downPayment = product.price * 0.2 * quantity;
                          }

                          totalAmount = merchandiseSubtotal + shippingFee;
                        });
                      },
                      items: ['Cash on Delivery', 'G-Cash'].map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                // Red "Cancel" button
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red, // Red button color
                    foregroundColor: Colors.white, // White text color
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Green "Proceed to Payment" button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green button color
                    foregroundColor: Colors.white, // White text color
                  ),
                  onPressed: () {
                    if (selectedPaymentMethod == 'Cash on Delivery') {
                      // Close the dialog and show the COD notice
                      Navigator.pop(context);
                      _showCashOnDeliveryNotice(
                        context,
                        product,
                        downPayment + shippingFee,
                      );
                    } else {
                      // Proceed directly to the QR code page for G-Cash
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrCodePage(
                            amount: totalAmount, // Full amount for G-Cash
                            paymentMethod: selectedPaymentMethod,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show Cash on Delivery Notice
  void _showCashOnDeliveryNotice(
    BuildContext context,
    Product product,
    double downPayment,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Cash on Delivery Notice',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'You have selected Cash on Delivery. You will pay a 20% down payment plus the shipping fee now. The remaining balance must be paid upon receiving your furniture. Do you want to proceed?',
            style: TextStyle(),
          ),
          actions: [
            // Red "Cancel" button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context), // Cancel the action
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Green "OK" button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green button color
                foregroundColor: Colors.white, // White text color
              ),
              onPressed: () {
                Navigator.pop(context); // Close the notice dialog
                // Proceed to QR code page for Cash on Delivery
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrCodePage(
                      amount: downPayment,
                      paymentMethod: 'Cash on Delivery',
                    ),
                  ),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
