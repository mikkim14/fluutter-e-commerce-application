import 'package:flutter/material.dart';
import 'sign_up.dart';

class FurnitureLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // NAVIGATION BAR
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sesno Sash',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01579B),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF0277BD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),

              // TAGLINE & SAMPLE ICONS
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Transform Your Home with Timeless Furniture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01579B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Discover luxury, comfort, and sustainability all in one place.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 30,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: const [
                        IconCard(icon: Icons.chair_alt, label: 'Chairs'),
                        IconCard(icon: Icons.king_bed_outlined, label: 'Beds'),
                        IconCard(
                          icon: Icons.table_restaurant_outlined,
                          label: 'Tables',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // WHY CHOOSE US SECTION
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Why Choose Sesno Sash?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF01579B),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: const [
                        FeatureCard(
                          icon: Icons.chair,
                          title: 'Comfort & Style',
                          description:
                              'Furniture designed to enhance both beauty and comfort in your home.',
                        ),
                        FeatureCard(
                          icon: Icons.eco,
                          title: 'Eco-Friendly Materials',
                          description:
                              'We use sustainable wood and eco-conscious materials.',
                        ),
                        FeatureCard(
                          icon: Icons.delivery_dining,
                          title: 'Fast Delivery',
                          description:
                              'Swift and safe delivery right to your doorstep.',
                        ),
                        FeatureCard(
                          icon: Icons.handyman,
                          title: 'Handcrafted Quality',
                          description:
                              'Each piece is built with precision and lasting craftsmanship.',
                        ),
                        FeatureCard(
                          icon: Icons.support_agent,
                          title: 'Exceptional Support',
                          description:
                              'We offer friendly and responsive customer service.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // CTA FOOTER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue[200]!, Colors.lightBlue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ready to Elevate Your Space?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01579B),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // FOOTER
              Container(
                width: double.infinity,
                color: const Color(0xFF01579B),
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  children: const [
                    Text(
                      'Sesno Sash Furniture',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '© 2025 Sesno Sash. All rights reserved.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// FEATURE CARD WIDGET
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.lightBlue[600]),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ICON CARD WIDGET
class IconCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.lightBlue),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
