import 'user.dart';

class UserSession {
  static String name = '';
  static String email = '';
  static List<User> users = [
    User(
      id: 1,
      fullName: 'Static User',
      email: 'user@example.com',
      password: 'user123',
      role: 'user',
      address: '',
      phone: '',
    ),
  ];

  // Method to register a user
  static void registerUser(User user) {
    users.add(user);
  }

  // Method to authenticate a user
  static User? authenticate(String email, String password) {
    try {
      return users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null; // Return null if user is not found
    }
  }

  // Method to set the current user (after authentication)
  static void setCurrentUser(User user) {
    name = user.fullName;
    email = user.email;
  }

  // Getter method to get the current user's address
  static String? getUserAddress() {
    final user = users.firstWhere(
      (u) => u.email == email,
      orElse: () => User(
        id: 0,
        fullName: '',
        email: email,
        password: '',
        role: '',
        address: '',
        phone: '',
      ), // Fallback to an empty user if not found
    );
    return user.address;
  }

  // Setter method to update the current user's address
  static void updateUserAddress(String newAddress) {
    final user = users.firstWhere(
      (u) => u.email == email,
      orElse: () => User(
        id: 0,
        fullName: '',
        email: email,
        password: '',
        role: '',
        address: '', // Default empty address
        phone: '',
      ),
    );

    // Update the user data
    int index = users.indexWhere((u) => u.email == email);
    if (index != -1) {
      users[index] = User(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        password: user.password,
        role: user.role,
        address: newAddress, // Update address
        phone: user.phone,
      );
    }
  }
}
