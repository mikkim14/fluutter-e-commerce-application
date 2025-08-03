// pages/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'product_management.dart';
import 'order_management.dart';
import 'payment_management.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Manage Products"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductManagement()),
              );
            },
          ),
          ListTile(
            title: Text("Manage Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderManagement()),
              );
            },
          ),
          ListTile(
            title: Text("Manage Payments"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PaymentManagement()),
              );
            },
          ),
        ],
      ),
    );
  }
}
