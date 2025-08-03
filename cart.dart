class Cart {
  static final List<String> items = [];

  static int get count => items.length;

  static void add(String item, {int quantity = 1}) {
    for (int i = 0; i < quantity; i++) {
      items.add(item);
    }
  }

  static void clear() {
    items.clear();
  }
}
