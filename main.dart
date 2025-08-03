import 'package:flutter/material.dart';
import 'pages/landing.dart';
import 'pages/login_page.dart';
import 'pages/sign_up.dart';
import 'pages/homepage.dart';
import 'pages/admin_dashboard.dart';
import 'models/order.dart';
import 'pages/order_details_page.dart';

void main() {
  runApp(SesnoFurnitureApp());
}

class SesnoFurnitureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sesno Sash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arial', useMaterial3: true),
      initialRoute: '/', // Initial route
      routes: {
        '/': (context) => FurnitureLandingPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/homepage': (context) => Homepage(),
        '/admin_dashboard': (context) => AdminDashboard(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/order_details') {
          final order = settings.arguments as Order;
          return MaterialPageRoute(
            builder: (context) => OrderDetailsPage(order: order),
          );
        }
        return null;
      },
    );
  }
}
