import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/product.dart';
import '../models/favorites.dart';
import '../models/cart.dart';
import 'view_product.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  void _removeFromFavorites(Product product) {
    setState(() {
      Favorites.remove(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.name} has been removed from your favorites.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _addToCart(Product product) {
    setState(() {
      Cart.add(product.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} has been added to your cart.'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = Favorites.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: favoriteProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.heartCrack,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Favorites Yet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap the heart on any product to save it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return InkWell(
                  onTap: () {
                    // Navigate to ViewProductPage when the card is tapped
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
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                'assets/images/${product.id}.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Php ${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.blue,
                            ),
                            onPressed: () => _addToCart(product),
                            tooltip: 'Add to Cart',
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _removeFromFavorites(product),
                            tooltip: 'Remove from Favorites',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
