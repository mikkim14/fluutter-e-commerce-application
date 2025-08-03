// models/payment.dart
class Payment {
  final int id;
  final int orderId;
  final double downPayment;
  final double remainingBalance;
  final String paymentStatus;
  final DateTime paymentDate;

  Payment({
    required this.id,
    required this.orderId,
    required this.downPayment,
    required this.remainingBalance,
    required this.paymentStatus,
    required this.paymentDate,
  });

  // Convert payment to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'down_payment': downPayment,
      'remaining_balance': remainingBalance,
      'payment_status': paymentStatus,
      'payment_date': paymentDate.toIso8601String(),
    };
  }

  // Convert map to payment object
  static Payment fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      orderId: map['order_id'],
      downPayment: map['down_payment'],
      remainingBalance: map['remaining_balance'],
      paymentStatus: map['payment_status'],
      paymentDate: DateTime.parse(map['payment_date']),
    );
  }
}
