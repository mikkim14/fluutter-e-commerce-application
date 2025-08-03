// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/product_catalog.dart';
import '../models/user_session.dart';
import 'payment_verification_page.dart';
import 'qr_code_page.dart';
import 'homepage.dart'; // Import the homepage for navigation
import 'view_product.dart'; // Import the ViewProductPage

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Helper to count quantities for each item
  Map<String, int> get _itemCounts {
    final counts = <String, int>{};
    for (final item in Cart.items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    return counts;
  }

  void _processOrderAndClearCart(String paymentMethod) {
    final itemCounts = _itemCounts;
    final user = UserSession.users.firstWhere(
      (u) => u.email == UserSession.email,
      orElse: () => UserSession.users.first,
    );

    for (final name in itemCounts.keys) {
      final product = _findProductByName(name);
      if (product != null) {
        // Generate a unique ID for each order
        final orderId = Order.orders.length + 1; // Simple unique ID generation

        // Add order with the generated ID
        Order.addOrder(
          id: orderId, // Pass the generated ID
          userId: user.id ?? 0,
          productName: name,
          quantity: itemCounts[name]!,
          itemPrice: product.price,
          paymentMethod: paymentMethod,
        );
      }
    }

    // Clear the cart after processing the order
    Cart.clear();

    // Trigger a rebuild to update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final itemCounts = _itemCounts;
    final itemNames = itemCounts.keys.toList();
    double totalCartPrice = 0;
    double downPayment = 0;
    double shippingFee = 200;

    for (final name in itemNames) {
      final product = _findProductByName(name);
      if (product != null) {
        totalCartPrice += product.price * itemCounts[name]!;
        downPayment +=
            (product.price * 0.2) * itemCounts[name]!; // 20% down payment
      }
    }

    String address = '';
    if (UserSession.users.isNotEmpty) {
      final user = UserSession.users.firstWhere(
        (u) => u.email == UserSession.email,
        orElse: () => UserSession.users.first,
      );
      address = user.address ?? '';
    }

    final addressIsSet =
        address.trim().isNotEmpty && address != '123 Main St, City, Country';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the Homepage directly
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE0F7FA).withOpacity(0.5),
              const Color(0xFFB3E5FC).withOpacity(0.5),
            ],
          ),
        ),
        child: itemCounts.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(
                    color: Color(0xFF01579B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: itemNames.length,
                      itemBuilder: (context, i) {
                        final name = itemNames[i];
                        final quantity = itemCounts[name]!;
                        final product = _findProductByName(name);

                        return GestureDetector(
                          onTap: () {
                            if (product != null) {
                              // Navigate to ViewProductPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewProductPage(
                                    product: product,
                                    productRatings: {},
                                    productReviews: {},
                                  ),
                                ),
                              );
                            }
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: product != null
                                          ? Image.asset(
                                              'assets/images/${product.id}.jpg',
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            )
                                          : Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF003366),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product != null
                                              ? 'Php ${product.price.toStringAsFixed(2)}'
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Color(0xFF01579B),
                                        ),
                                        onPressed: quantity > 1
                                            ? () {
                                                setState(() {
                                                  final idx = Cart.items
                                                      .indexOf(name);
                                                  if (idx != -1)
                                                    Cart.items.removeAt(idx);
                                                });
                                              }
                                            : null,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF01579B,
                                          ).withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '$quantity',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF01579B),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Color(0xFF0288D1),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Cart.add(name);
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Cart.items.removeWhere(
                                              (item) => item == name,
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Payment: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003366),
                              ),
                            ),
                            Text(
                              'Php ${(downPayment + shippingFee).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01579B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: itemCounts.isEmpty || !addressIsSet
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String paymentMethod = 'Cash on Delivery';
                                    double shippingFee = 200;
                                    double total = totalCartPrice + shippingFee;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          title: const Text(
                                            'Checkout Summary',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF01579B),
                                                          Color(0xFF0288D1),
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ...itemNames.map((name) {
                                                      final product =
                                                          _findProductByName(
                                                            name,
                                                          );
                                                      final quantity =
                                                          itemCounts[name]!;
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 4,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              child: SizedBox(
                                                                width: 32,
                                                                height: 32,
                                                                child:
                                                                    product !=
                                                                        null
                                                                    ? Image.asset(
                                                                        'assets/images/${product.id}.jpg',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorBuilder:
                                                                            (
                                                                              context,
                                                                              error,
                                                                              stackTrace,
                                                                            ) => Container(
                                                                              color: Colors.grey[200],
                                                                              child: const Icon(
                                                                                Icons.image_not_supported,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                      )
                                                                    : Container(
                                                                        color: Colors
                                                                            .grey[200],
                                                                        child: const Icon(
                                                                          Icons
                                                                              .image_not_supported,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                product?.name ??
                                                                    name,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              'x$quantity',
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              product != null
                                                                  ? 'Php ${product.price.toStringAsFixed(2)}'
                                                                  : '',
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .greenAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    const Divider(
                                                      color: Colors.white70,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Shipping Fee:',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Php ${shippingFee.toStringAsFixed(2)}',
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (paymentMethod ==
                                                        'Cash on Delivery')
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            '20% Down Payment:',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Php ${(() {
                                                              double downPayment = 0;
                                                              for (final name in itemNames) {
                                                                final product = _findProductByName(name);
                                                                final quantity = itemCounts[name]!;
                                                                if (product != null) {
                                                                  downPayment += (product.price * 0.2) * quantity;
                                                                }
                                                              }
                                                              return downPayment.toStringAsFixed(2);
                                                            })()}',
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .greenAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Total Amount:',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Php ${total.toStringAsFixed(2)}',
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Total Payment: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Php ${(downPayment + shippingFee).toStringAsFixed(2)}',
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  49,
                                                                  153,
                                                                  39,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (paymentMethod ==
                                                        'Cash on Delivery')
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Balance Due:',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Php ${(() {
                                                              double downPayment = 0;
                                                              for (final name in itemNames) {
                                                                final product = _findProductByName(name);
                                                                final quantity = itemCounts[name]!;
                                                                if (product != null) {
                                                                  downPayment += (product.price * 0.2) * quantity;
                                                                }
                                                              }
                                                              downPayment += shippingFee;
                                                              double balanceDue = total - downPayment;
                                                              return balanceDue.toStringAsFixed(2);
                                                            })()}',
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              DropdownButtonFormField<String>(
                                                value: paymentMethod,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText:
                                                          'Payment Method',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'Cash on Delivery',
                                                    child: Text(
                                                      'Cash on Delivery',
                                                    ),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'GCash',
                                                    child: Text('GCash'),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    paymentMethod =
                                                        value ??
                                                        'Cash on Delivery';
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF01579B,
                                                ),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (paymentMethod ==
                                                    'Cash on Delivery') {
                                                  double downPayment = 0;
                                                  for (final name
                                                      in itemNames) {
                                                    final product =
                                                        _findProductByName(
                                                          name,
                                                        );
                                                    final quantity =
                                                        itemCounts[name]!;
                                                    if (product != null) {
                                                      downPayment +=
                                                          (product.price *
                                                              0.2) *
                                                          quantity;
                                                    }
                                                  }
                                                  downPayment += shippingFee;
                                                  double balanceDue =
                                                      total - downPayment;
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'Cash on Delivery Notice',
                                                        ),
                                                        content: const Text(
                                                          'You have selected Cash on Delivery. You will pay a 20% down payment plus the shipping fee now. The remaining balance must be paid upon receiving your furniture. Do you want to proceed?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                ),
                                                            child: const Text(
                                                              'Cancel',
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFF01579B,
                                                                  ),
                                                              foregroundColor:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => QrCodePage(
                                                                    amount:
                                                                        downPayment,
                                                                    paymentMethod:
                                                                        paymentMethod,
                                                                    onPaymentVerified: () {
                                                                      Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder:
                                                                              (
                                                                                context,
                                                                              ) => PaymentVerificationPage(
                                                                                amount: downPayment,
                                                                                paymentMethod: paymentMethod,
                                                                                onPaymentComplete: () {
                                                                                  _processOrderAndClearCart(
                                                                                    paymentMethod,
                                                                                  );
                                                                                },
                                                                              ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              'OK',
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else if (paymentMethod ==
                                                    'GCash') {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => QrCodePage(
                                                        amount:
                                                            totalCartPrice +
                                                            shippingFee,
                                                        paymentMethod:
                                                            paymentMethod,
                                                        onPaymentVerified: () {
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => PaymentVerificationPage(
                                                                amount:
                                                                    totalCartPrice +
                                                                    shippingFee,
                                                                paymentMethod:
                                                                    paymentMethod,
                                                                onPaymentComplete: () {
                                                                  _processOrderAndClearCart(
                                                                    paymentMethod,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Confirm Order',
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Product? _findProductByName(String name) {
    return ProductCatalog.allProducts.firstWhere(
      (p) => p.name == name,
      orElse: () => Product(
        id: 0,
        name: name,
        description: '',
        price: 0,
        stockQuantity: 0,
      ),
    );
  }
}
