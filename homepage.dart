import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import '../models/order.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import '../models/product.dart';
import '../models/product_catalog.dart';
import '../models/cart.dart';
import 'order_management.dart';
import 'product_management.dart';
import 'profile_page.dart';
import '../models/user_session.dart';
import 'package:sesno/pages/help_support_page.dart';
import 'package:sesno/pages/qr_code_page.dart';
import '../models/user.dart';
import '../models/favorites.dart';
import 'payment_verification_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  int get cartItemCount => Cart.count;
  String? selectedCategory;
  String searchQuery = '';
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Sample categories and products data
  final List<String> categories = [
    'All',
    'Sofas',
    'Chairs',
    'Tables',
    'Beds',
    'Storage',
  ];

  // Use the shared product list from ProductCatalog
  final List<Product> allProducts = ProductCatalog.allProducts;

  List<Product> get filteredProducts {
    List<Product> products = allProducts;
    if (selectedCategory != null && selectedCategory != 'All') {
      products = products.where((product) {
        final productName = product.name.toLowerCase();
        switch (selectedCategory) {
          case 'Sofas':
            return productName.contains('sofa') ||
                productName.contains('chaise');
          case 'Chairs':
            return productName.contains('chair') ||
                productName.contains('armchair');
          case 'Tables':
            return productName.contains('table');
          case 'Beds':
            return productName.contains('bed');
          case 'Storage':
            return productName.contains('wardrobe') ||
                productName.contains('bookshelf') ||
                productName.contains('cabinet');
          default:
            return true;
        }
      }).toList();
    }
    if (searchQuery.isNotEmpty) {
      products = products
          .where(
            (product) =>
                product.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
    return products;
  }

  // Function to show payment details dialog
  void _showPaymentDetailsDialog(BuildContext context, Product product) {
    double shippingFee = 200;
    int quantity = 1;

    // Calculate down payment for Cash on Delivery (20% of the product price * quantity)
    double downPayment = product.price * 0.2 * quantity;
    double merchandiseSubtotal = product.price * quantity;
    double totalAmount = merchandiseSubtotal + shippingFee;
    String selectedPaymentMethod = 'Cash on Delivery';

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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount:',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Php ${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

                    // Payment Method Selection
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

                    // Quantity Adjusters
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Quantity: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: quantity > 1
                              ? () => setState(() {
                                  quantity--;
                                  // Recalculate the down payment and total amount when quantity changes
                                  downPayment = product.price * 0.2 * quantity;
                                  merchandiseSubtotal =
                                      product.price * quantity;
                                  totalAmount =
                                      merchandiseSubtotal + shippingFee;
                                })
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
                          onPressed: () => setState(() {
                            quantity++;
                            // Recalculate the down payment and total amount when quantity changes
                            downPayment = product.price * 0.2 * quantity;
                            merchandiseSubtotal = product.price * quantity;
                            totalAmount = merchandiseSubtotal + shippingFee;
                          }),
                        ),
                      ],
                    ),
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
                    final orderId =
                        Order.orders.length + 1; // Generate unique ID
                    Order.addOrder(
                      id: orderId, // Pass the generated ID
                      userId: 1, // Use actual userId here
                      productName: product.name,
                      quantity: quantity,
                      itemPrice: product.price,
                      paymentMethod: selectedPaymentMethod,
                    );
                    if (selectedPaymentMethod == 'Cash on Delivery') {
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
                            amount: totalAmount,
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
                ).then((_) {
                  // After QR Code confirmation, proceed to PaymentVerificationPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentVerificationPage(
                        amount: downPayment,
                        paymentMethod: 'Cash on Delivery',
                      ),
                    ),
                  );
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              )
            : const Text(
                'Sesno Furniture',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchQuery = '';
                  _searchController.clear();
                } else {
                  isSearching = true;
                }
              });
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.cartShopping),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ).then((_) => setState(() {})); // Refresh badge on return
                },
              ),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$cartItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF01579B), Color(0xFF0288D1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sesno Furniture',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.house,
                    title: 'Home',
                    onTap: () => Navigator.pop(context),
                    isSelected: true,
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.list,
                    title: 'Products',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductManagement(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.heart,
                    title: 'Favorites',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesPage(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.bagShopping,
                    title: 'Orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderManagement(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.user,
                    title: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.rightFromBracket,
                    title: 'Logout',
                    onTap: () {
                      // Clear user session and navigate to login
                      UserSession.name = '';
                      UserSession.email = '';
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header with Gradient Background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/furniture_background.webp',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.7),
                      BlendMode.lighten,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 34, 32, 32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sesno Furniture',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover premium furniture for your home',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 34, 32, 32),
                      ),
                    ),
                  ],
                ),
              ),
              // Category Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shop By Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected =
                              selectedCategory == category ||
                              (selectedCategory == null && category == 'All');
                          return FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category == 'All'
                                    ? null
                                    : category;
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xFF01579B),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF01579B),
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                            ),
                            avatar: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Product Section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          onBuyNow: () {
                            _showProductDetailsDialog(
                              context,
                              filteredProducts[index],
                            );
                          },
                          onAddToCart: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                int quantity = 1;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Add to Cart'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            filteredProducts[index].name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Php ${filteredProducts[index].price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: quantity > 1
                                                    ? () => setState(
                                                        () => quantity--,
                                                      )
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
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              Cart.add(
                                                filteredProducts[index].name,
                                                quantity: quantity,
                                              );
                                            });
                                            Navigator.pop(context);
                                            // Update badge
                                            this.setState(() {});
                                          },
                                          child: const Text('Add to Cart'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int quantity = 1;
  String selectedPaymentMethod = 'G-Cash';
  final paymentMethods = ['G-Cash', 'Cash on Delivery'];

  void _showProductDetailsDialog(BuildContext context, Product product) {
    bool isFavorite = Favorites.isFavorite(product);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with dynamic aspect ratio
                    Center(
                      child: FutureBuilder<ImageInfo>(
                        future: _loadImageInfo(
                          'assets/images/${product.id}.jpg',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final imageInfo = snapshot.data!;
                            double aspectRatio =
                                imageInfo.image.width / imageInfo.image.height;
                            return AspectRatio(
                              aspectRatio: aspectRatio,
                              child: Image.asset(
                                'assets/images/${product.id}.jpg',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 160,
                                      width: 160,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 160,
                              width: 160,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                                Favorites.remove(product);
                              } else {
                                Favorites.add(product);
                              }
                              isFavorite = !isFavorite;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite
                                      ? '${product.name} added to favorites!'
                                      : '${product.name} removed from favorites.',
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.rate_review),
                          tooltip: 'Customer Reviews',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final List<String> reviews = [];
                                return AlertDialog(
                                  title: const Text('Customer Reviews'),
                                  content: reviews.isNotEmpty
                                      ? SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: reviews.length,
                                            separatorBuilder: (c, i) =>
                                                const Divider(),
                                            itemBuilder: (c, i) => ListTile(
                                              leading: const Icon(Icons.person),
                                              title: Text(reviews[i]),
                                            ),
                                          ),
                                        )
                                      : const Text('No reviews yet.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Php ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 24),
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
                              Navigator.pop(context);
                              _showPaymentDetailsDialog(context, product);
                            },
                            child: const Text(
                              'Proceed to Payment',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Load image info (width and height)
  Future<ImageInfo> _loadImageInfo(String path) async {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    final Image image = Image.asset(path);

    image.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
            completer.complete(imageInfo);
          }),
        );

    return completer.future;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF003366).withOpacity(0.1) : null,
      ),
      child: ListTile(
        leading: FaIcon(
          icon,
          color: isDestructive
              ? Colors.red[600]
              : isSelected
              ? const Color(0xFF003366)
              : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive
                ? Colors.red[600]
                : isSelected
                ? const Color(0xFF003366)
                : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final user = UserSession.users.firstWhere(
          (u) => u.email == UserSession.email,
          orElse: () => User(
            id: 0,
            fullName: '',
            email: '',
            password: '',
            role: '',
            address: '',
            phone: '',
          ),
        );
        if (user.address == null || user.address?.trim().isEmpty == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Address Required'),
              content: const Text(
                'Please add your address in your profile before proceeding to payment.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          onBuyNow();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/${product.id}.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
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
                const SizedBox(height: 8),
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Php ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01579B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final user = UserSession.users.firstWhere(
                            (u) => u.email == UserSession.email,
                            orElse: () => User(
                              id: 0,
                              fullName: '',
                              email: '',
                              password: '',
                              role: '',
                              address: '',
                              phone: '',
                            ),
                          );
                          if (user.address == null ||
                              user.address?.trim().isEmpty == true) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Address Required'),
                                content: const Text(
                                  'Please add your address in your profile before proceeding to payment.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            onBuyNow();
                          }
                        },
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.cartPlus),
                      onPressed: onAddToCart,
                      color: const Color(0xFF01579B),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
