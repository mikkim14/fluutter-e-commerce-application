import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/order.dart';
import '../models/product_catalog.dart';

class OrderManagement extends StatelessWidget {
  int _getProductId(String name) {
    try {
      final product = ProductCatalog.allProducts.firstWhere(
        (p) => p.name == name,
      );
      return product.id;
    } catch (e) {
      return 0;
    }
  }

  const OrderManagement({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'To Ship':
        return Colors.orange;
      case 'To Deliver':
        return Colors.blue;
      case 'To Rate':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _paymentIcon(String method) {
    switch (method) {
      case 'G-Cash':
        return FontAwesomeIcons.wallet;
      case 'Cash on Delivery':
        return FontAwesomeIcons.moneyBillWave;
      default:
        return FontAwesomeIcons.moneyCheckDollar;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sorting orders based on status:
    List<Order> sortedOrders = Order.orders;

    sortedOrders.sort((a, b) {
      if (a.status == 'To Ship' && b.status != 'To Ship') return -1;
      if (b.status == 'To Ship' && a.status != 'To Ship') return 1;
      if (a.status == 'Cancelled' && b.status != 'Cancelled') return 1;
      if (b.status == 'Cancelled' && a.status != 'Cancelled') return -1;
      return 0; // Preserve original order for received and other statuses
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Order Management"),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: sortedOrders.isEmpty
          ? const Center(child: Text("No orders yet."))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sortedOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final order = sortedOrders[i];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/order_details',
                          arguments: order,
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: constraints.maxWidth < 400
                                          ? 36
                                          : 48,
                                      height: constraints.maxWidth < 400
                                          ? 36
                                          : 48,
                                      child: Image.asset(
                                        'assets/images/${_getProductId(order.productName)}.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
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
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.productName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color(0xFF003366),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _statusColor(
                                              order.status,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                order.status == 'To Ship'
                                                    ? Icons.local_shipping
                                                    : order.status ==
                                                          'To Deliver'
                                                    ? Icons.home
                                                    : order.status == 'To Rate'
                                                    ? Icons.star
                                                    : Icons.cancel,
                                                color: _statusColor(
                                                  order.status,
                                                ),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                order.status,
                                                style: TextStyle(
                                                  color: _statusColor(
                                                    order.status,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    _paymentIcon(order.paymentMethod),
                                    size: 18,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    order.paymentMethod,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Date: ${order.orderDate.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quantity:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '${order.quantity}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          'Php ${order.itemPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Shipping:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          'Php 200.00',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Total: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    'Php ${order.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (order.status != 'Cancelled')
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        backgroundColor: Colors.red.withOpacity(
                                          0.08,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        String? reason;
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Cancel Order'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    'Please select a reason for cancellation:',
                                                  ),
                                                  const SizedBox(height: 12),
                                                  DropdownButtonFormField<
                                                    String
                                                  >(
                                                    decoration:
                                                        const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value:
                                                            'Order placed by mistake',
                                                        child: Text(
                                                          'Order placed by mistake',
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            'Changed my mind',
                                                        child: Text(
                                                          'Changed my mind',
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            'Found a better alternative',
                                                        child: Text(
                                                          'Found a better alternative',
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            'Price is too high',
                                                        child: Text(
                                                          'Price is too high',
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            'Delayed delivery',
                                                        child: Text(
                                                          'Delayed delivery',
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            'Item no longer needed',
                                                        child: Text(
                                                          'Item no longer needed',
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 'Other',
                                                        child: Text('Other'),
                                                      ),
                                                    ],
                                                    onChanged: (val) {
                                                      reason = val;
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                            255,
                                                            216,
                                                            55,
                                                            44,
                                                          ),
                                                      color: Color.fromARGB(
                                                        255,
                                                        255,
                                                        255,
                                                        255,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color.fromARGB(
                                                              255,
                                                              22,
                                                              212,
                                                              54,
                                                            ),
                                                      ),
                                                  onPressed: () {
                                                    if (reason != null &&
                                                        reason!.isNotEmpty) {
                                                      Order.orders[i] = Order(
                                                        id: order.id,
                                                        userId: order.userId,
                                                        orderDate:
                                                            order.orderDate,
                                                        status: 'Cancelled',
                                                        totalAmount:
                                                            order.totalAmount,
                                                        productName:
                                                            order.productName,
                                                        quantity:
                                                            order.quantity,
                                                        itemPrice:
                                                            order.itemPrice,
                                                        paymentMethod:
                                                            order.paymentMethod,
                                                        cancelReason: reason,
                                                      );
                                                      Navigator.pop(context);
                                                      (context as Element)
                                                          .markNeedsBuild();
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Confirm Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.cancel, size: 18),
                                      label: const Text('Cancel'),
                                    ),
                                ],
                              ),
                              if (order.status == 'Cancelled' &&
                                  order.cancelReason != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Cancelled Reason: ${order.cancelReason}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
