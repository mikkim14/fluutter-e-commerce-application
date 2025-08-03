// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import '../services/database_service.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/product_catalog.dart';
import '../models/favorites.dart';
import 'cart_page.dart';
import 'qr_code_page.dart';
import 'payment_verification_page.dart';
import '../models/user_session.dart';
import '../models/order.dart';
import '../models/user.dart';
import 'view_product.dart';
import '../models/review.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  late DatabaseService databaseService;
  String selectedCategory = 'All';
  String searchQuery = '';
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Build categoryProducts from ProductCatalog.allProducts
  Map<String, List<Product>> get categoryProducts {
    final Map<String, List<Product>> map = {
      'Sofas': [],
      'Chairs': [],
      'Beds': [],
      'Tables': [],
      'Storage': [],
    };
    for (final product in ProductCatalog.allProducts) {
      final name = product.name.toLowerCase();
      if (name.contains('sofa') ||
          name.contains('loveseat') ||
          name.contains('sectional')) {
        map['Sofas']!.add(product);
      } else if (name.contains('chair') ||
          name.contains('armchair') ||
          name.contains('stool')) {
        map['Chairs']!.add(product);
      } else if (name.contains('bed')) {
        map['Beds']!.add(product);
      } else if (name.contains('table')) {
        map['Tables']!.add(product);
      } else if (name.contains('wardrobe') ||
          name.contains('cabinet') ||
          name.contains('bookshelf') ||
          name.contains('dresser') ||
          name.contains('bench') ||
          name.contains('chest')) {
        map['Storage']!.add(product);
      }
    }
    return map;
  }

  final List<String> categories = [
    'All',
    'Sofas',
    'Chairs',
    'Beds',
    'Tables',
    'Storage',
  ];

  // Static reviews for products
  final Map<int, List<Review>> productReviews = {
    1: [
      Review(
        userName: 'Maria Santos',
        rating: 5.0,
        comment:
            'Excellent quality! The modular design is perfect for our living room.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        productId: 1,
      ),
      Review(
        userName: 'John Dela Cruz',
        rating: 4.5,
        comment: 'Very comfortable and stylish. Delivery was fast.',
        date: DateTime.now().subtract(const Duration(days: 5)),
        productId: 1,
      ),
    ],
    2: [
      Review(
        userName: 'Ana Reyes',
        rating: 4.0,
        comment: 'Modern design and good comfort. Perfect for small spaces.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        productId: 2,
      ),
    ],
    3: [
      Review(
        userName: 'Carlos Mendoza',
        rating: 5.0,
        comment: 'Luxurious feel and great craftsmanship. Highly recommended!',
        date: DateTime.now().subtract(const Duration(days: 3)),
        productId: 3,
      ),
      Review(
        userName: 'Lisa Garcia',
        rating: 4.5,
        comment: 'Beautiful bed frame. Assembly was straightforward.',
        date: DateTime.now().subtract(const Duration(days: 7)),
        productId: 3,
      ),
    ],
    4: [
      Review(
        userName: 'Roberto Torres',
        rating: 4.0,
        comment: 'Solid wooden table. Perfect for family dinners.',
        date: DateTime.now().subtract(const Duration(days: 4)),
        productId: 4,
      ),
    ],
    5: [
      Review(
        userName: 'Sofia Lopez',
        rating: 4.5,
        comment:
            'Comfortable chair with great ergonomics. Good for long hours.',
        date: DateTime.now().subtract(const Duration(days: 6)),
        productId: 5,
      ),
    ],
  };

  // Average ratings for products
  final Map<int, double> productRatings = {
    1: 4.75,
    2: 4.0,
    3: 4.75,
    4: 4.0,
    5: 4.5,
  };

  int get cartItemCount => Cart.count;

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
  }

  List<Product> get filteredProducts {
    List<Product> products;
    if (selectedCategory == 'All') {
      products = categoryProducts.values
          .expand((products) => products)
          .toList();
    } else {
      products = categoryProducts[selectedCategory] ?? [];
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

  // ignore: unused_element
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Sofas':
        return FontAwesomeIcons.couch;
      case 'Chairs':
        return FontAwesomeIcons.chair;
      case 'Beds':
        return FontAwesomeIcons.bed;
      case 'Tables':
        return FontAwesomeIcons.table;
      case 'Storage':
        return FontAwesomeIcons.boxOpen;
      default:
        return FontAwesomeIcons.box;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCounts = <String, int>{};
    for (final item in Cart.items) {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
    }
    final itemNames = itemCounts.keys.toList();
    double totalCartPrice = 0;
    // Use all products from this page
    final allProducts = ProductCatalog.allProducts;
    for (final name in itemNames) {
      final product = allProducts.firstWhere(
        (p) => p.name == name,
        orElse: () => Product(
          id: 0,
          name: name,
          description: '',
          price: 0,
          stockQuantity: 0,
        ),
      );
      totalCartPrice += product.price * itemCounts[name]!;
    }
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              )
            : const Text(
                'Furniture Products',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
        elevation: 0,
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
              if (cartItemCount > 0)
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
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF01579B),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF01579B),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF01579B)
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              },
            ),
          ),

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProductPage(
                          product: product,
                          productRatings: productRatings,
                          productReviews: productReviews,
                        ),
                      ),
                    );
                  },
                  child: ProductCard(
                    product: product,
                    productRatings: productRatings,
                    productReviews: productReviews,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Map<int, double> productRatings;
  final Map<int, List<Review>> productReviews;

  const ProductCard({
    super.key,
    required this.product,
    required this.productRatings,
    required this.productReviews,
  });

  void _onBuyNow(BuildContext context) {
    _showProductDetails(context);
  }

  void _showProductDetails(BuildContext context) {
    final reviews = productReviews[product.id] ?? [];
    final rating = productRatings[product.id] ?? 0.0;
    bool isFavorite = Favorites.isFavorite(product);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
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
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image/Icon
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
                                  imageInfo.image.width /
                                  imageInfo.image.height;
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

                      // Product Details
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
                        'Stock: ${product.stockQuantity}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 24),

                      // Rating Section
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
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF01579B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                _onAddToCart(context);
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                // Generate a unique orderId (assuming Order.orders starts empty or sequential)
                                final orderId = Order.orders.length + 1;
                                final user = UserSession.users.firstWhere(
                                  (u) => u.email == UserSession.email,
                                  orElse: () => User(
                                    id: 0,
                                    fullName: '',
                                    email: '',
                                    password: '',
                                    role: '',
                                  ),
                                );

                                // Add the order to the Order management system
                                Order.addOrder(
                                  id: orderId,
                                  userId: user.id ?? 0,
                                  productName: product.name,
                                  quantity: 1,
                                  itemPrice: product.price,
                                  paymentMethod: 'Cash on Delivery',
                                );

                                // Proceed to the payment details dialog
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
                      const SizedBox(height: 24),

                      // Reviews Section
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reviews List
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Be the first to review this product!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 4),
                                      Text(review.comment),
                                      const SizedBox(height: 4),
                                      Text(
                                        review.date.toLocal().toString(),
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
                    ],
                  ),
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

  Future<ImageInfo> _loadImageInfo(String assetPath) async {
    final image = AssetImage(assetPath);
    final completer = Completer<ImageInfo>();
    image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            completer.complete(info);
          }),
        );
    return completer.future;
  }

  void _onAddToCart(BuildContext context) {
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
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Php ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
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
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
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
                    Cart.add(product.name, quantity: quantity);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
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
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xFF01579B),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              'Php ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/${product.id}.jpg',
                    fit: BoxFit.cover,
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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    onPressed: () => _onBuyNow(context),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF01579B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.cartPlus),
                    color: Colors.white,
                    onPressed: () => _onAddToCart(context),
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
