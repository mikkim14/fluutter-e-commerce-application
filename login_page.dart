import 'package:flutter/material.dart';
import 'homepage.dart';
import '../models/user.dart';
import 'admin_dashboard.dart';
import '../models/user_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Hardcoded list of users for testing (can be replaced with DB or API in the future)
  final List<User> users = [
    User(
      id: 1,
      fullName: 'User Test',
      email: 'User1@gmail.com',
      password: 'user1@123',
      role: 'user',
      address: '123 Main St, Springfield, IL, 62701', // User address
    ),
    User(
      id: 2,
      fullName: 'Admin User',
      email: 'admin@gmail.com',
      password: 'admin@123',
      role: 'admin',
      address: '456 Admin Ave, Springfield, IL, 62701', // Admin's address
    ),
  ];

  void _loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      // Find the user by email and password
      User? user =
          users
              .where((user) => user.email == email && user.password == password)
              .isNotEmpty
          ? users.firstWhere(
              (user) => user.email == email && user.password == password,
            )
          : null;

      if (user != null) {
        UserSession.setCurrentUser(user); // Set the user in the session

        // Navigate based on user role
        if (user.role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboard(),
            ), // Admin navigation
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01579B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF01579B)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF01579B)),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01579B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _loginUser,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(
                          color: Color(0xFF01579B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
