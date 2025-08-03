import 'review.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.reviews = const [],
  });

  // Convert map to product object
  static Product fromMap(Map<String, dynamic> map) {
    var reviewList = <Review>[];
    if (map['reviews'] != null) {
      for (var reviewMap in map['reviews']) {
        reviewList.add(Review.fromMap(reviewMap));
      }
    }
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      stockQuantity: map['stock_quantity'],
      reviews: reviewList,
    );
  }

  // Convert product object to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }
}
