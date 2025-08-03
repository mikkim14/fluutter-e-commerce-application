class Order {
  static List<Order> orders = [];

  final int id;
  final int userId;
  final String productName;
  final int quantity;
  final double itemPrice;
  final String paymentMethod;
  final double totalAmount;
  final DateTime orderDate;
  String status;
  String? cancelReason;
  bool isDeleted; // Added isDeleted flag to mark orders as deleted

  // Constructor
  Order({
    required this.id,
    required this.userId,
    required this.productName,
    required this.quantity,
    required this.itemPrice,
    required this.paymentMethod,
    required this.totalAmount,
    required this.orderDate,
    this.status = 'To Ship',
    this.cancelReason,
    this.isDeleted = false, // Default value is false
  });

  // Add order to the list
  static void addOrder({
    required int id,
    required int userId,
    required String productName,
    required int quantity,
    required double itemPrice,
    required String paymentMethod,
  }) {
    final orderDate = DateTime.now();
    final totalAmount = itemPrice * quantity + 200; // Include shipping fee
    final order = Order(
      id: id,
      userId: userId,
      productName: productName,
      quantity: quantity,
      itemPrice: itemPrice,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      orderDate: orderDate,
    );
    orders.add(order); // Add the new order to the list
  }

  // Mark an order as deleted (soft delete)
  static void deleteOrder(int orderId) {
    final order = orders.firstWhere((order) => order.id == orderId);
    order.isDeleted = true; // Mark order as deleted
  }

  // Optional: To clean up orders that are marked as deleted, you can use a method to filter them out
  static List<Order> getActiveOrders() {
    return orders.where((order) => !order.isDeleted).toList();
  }
}
