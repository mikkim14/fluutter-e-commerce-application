class Review {
  final String userName;
  final int productId;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  // Convert map to review object
  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      userName: map['userName'],
      productId: map['productId'], // productId
      rating: map['rating'],
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }

  // Convert review object to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'productId': productId, // Store the productId
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
