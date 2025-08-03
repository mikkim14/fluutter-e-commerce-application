import '../models/product.dart';

class Favorites {
  static final List<Product> _favoriteItems = [];

  static List<Product> get items => _favoriteItems;

  static void add(Product product) {
    if (!isFavorite(product)) {
      _favoriteItems.add(product);
    }
  }

  static void remove(Product product) {
    _favoriteItems.removeWhere((item) => item.id == product.id);
  }

  static bool isFavorite(Product product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }
}
