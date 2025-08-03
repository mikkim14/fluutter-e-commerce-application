import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'profile_page.dart';

class PaymentManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get address from the currently logged-in user
    String address = '';
    if (UserSession.users.isNotEmpty) {
      final user = UserSession.users.firstWhere(
        (u) => u.email == UserSession.email,
        orElse: () => UserSession.users.first,
      );
      address = user.address ?? '';
    }

    // Check if the address is set
    final addressIsSet =
        address.trim().isNotEmpty && address != '123 Main St, City, Country';

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Management"),
        backgroundColor: Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: addressIsSet
          ? Center(child: Text("Manage payments here"))
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please add your address to proceed with payment.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to ProfilePage to update the address
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfilePage()),
                        );
                      },
                      child: Text('Go to Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF01579B),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
