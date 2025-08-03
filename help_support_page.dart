import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'icon': FontAwesomeIcons.userPlus,
        'title': '1. Sign Up or Log In',
        'desc': 'Create an account or log in to access all features.',
      },
      {
        'icon': FontAwesomeIcons.house,
        'title': '2. Browse Products',
        'desc': 'Explore new arrivals and shop by category on the homepage.',
      },
      {
        'icon': FontAwesomeIcons.magnifyingGlass,
        'title': '3. Search & Filter',
        'desc':
            'Use the search bar or category filters to find products quickly.',
      },
      {
        'icon': FontAwesomeIcons.cartShopping,
        'title': '4. Add to Cart',
        'desc': 'Add your favorite items to the cart for easy checkout.',
      },
      {
        'icon': FontAwesomeIcons.creditCard,
        'title': '5. Checkout & Payment',
        'desc':
            'Proceed to checkout, select a payment method, and complete your order.',
      },
      {
        'icon': FontAwesomeIcons.truck,
        'title': '6. Track Orders',
        'desc': 'View and track your orders from the Orders section.',
      },
      {
        'icon': FontAwesomeIcons.user,
        'title': '7. Manage Profile',
        'desc': 'Update your profile and address information anytime.',
      },
      {
        'icon': FontAwesomeIcons.circleQuestion,
        'title': 'Need More Help?',
        'desc': 'Contact support or check the FAQ for more information.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF01579B),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF01579B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(
                      step['icon'] as IconData,
                      color: const Color(0xFF01579B),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF003366),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step['desc'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text(
              'How do I reset my password?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text(
                  'On the login page, tap "Forgot Password?" and follow the instructions to reset your password.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              'How do I track my order?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text(
                  'Go to the Orders section from the menu to view and track your orders.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              'Can I change my delivery address?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text(
                  'Yes, you can update your address in the Profile section before placing an order.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              'What payment methods are accepted?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text('We accept G-Cash and Cash on Delivery.'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            color: const Color(0xFF01579B).withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.email, color: Color(0xFF01579B), size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Contact Support',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF003366),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Email: support@sesnofurniture.com',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'We usually respond within 24 hours.',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
