import 'package:flutter/material.dart';
import '../models/order.dart';
import 'order_details_page.dart';
import '../models/user_session.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  String name = 'John Doe';
  String email = 'johndoe@email.com';
  String address = '123 Main St, City, Country';
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = UserSession.name.isNotEmpty ? UserSession.name : 'John Doe';
    email = UserSession.email.isNotEmpty
        ? UserSession.email
        : 'johndoe@email.com';
    address = UserSession.getUserAddress() ?? '123 Main St, City, Country';
    nameController.text = name;
    emailController.text = email;
    addressController.text = address;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  void _toggleEdit() {
    setState(() {
      if (isEditing) {
        name = nameController.text;
        email = emailController.text;
        address = addressController.text;

        // Save the updated address in UserSession
        if (address.isEmpty || address == '123 Main St, City, Country') {
          address = '';
        }

        UserSession.updateUserAddress(address);
      }
      isEditing = !isEditing;
    });
  }

  void _deleteAccount() async {
    final ongoingOrders = Order.orders
        .where(
          (order) =>
              order.status != 'Cancelled' &&
              order.status != 'To Rate' &&
              !order.isDeleted,
        )
        .toList();

    if (ongoingOrders.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You cannot delete your account while you have ongoing orders.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Mark user's orders as deleted or remove them from the list
      for (var order in ongoingOrders) {
        Order.deleteOrder(order.id);
      }

      // Clear the user session data (Logout)
      UserSession.setCurrentUser(
        User(id: 0, fullName: '', email: '', password: '', role: ''),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Optionally, navigate the user to a login page or splash screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = Order.orders;
    final addressIsSet =
        address.trim().isNotEmpty && address != '123 Main St, City, Country';
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF01579B), Color(0xFF0288D1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF01579B), Color(0xFF0288D1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                if (!addressIsSet)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 24,
                      right: 24,
                      bottom: 8,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Text(
                        'Please add your address to your profile to enable purchases and deliveries.',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Profile Initials Avatar (no camera icon)
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF01579B),
                          ),
                        ),
                      ),
                      // User Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                      // Edit/Save Icon
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.save : Icons.edit,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleEdit,
                        tooltip: isEditing ? 'Save' : 'Edit',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Editable User Info Card
                _buildSectionCard(
                  title: 'Account Info',
                  child: Column(
                    children: [
                      _buildEditableField(
                        'Name',
                        nameController,
                        isEditing,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableField(
                        'Email',
                        emailController,
                        isEditing,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableField(
                        'Address',
                        addressController,
                        isEditing,
                        icon: Icons.location_on,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Order History Card with actions (taller)
                _buildSectionCard(
                  title: 'Order History',
                  minHeight: 260,
                  child: orders.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No orders yet.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Colors.black12),
                          itemBuilder: (context, i) {
                            final order = orders[i];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/images/${order.id}.jpg',
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
                              title: Text(
                                order.productName,
                                style: const TextStyle(
                                  color: Color(0xFF003366),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Qty: ${order.quantity} | Total: Php ${order.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildOrderStatusChipWithIcon(order.status),
                                  const SizedBox(width: 4),
                                ],
                              ),
                              onTap: () {
                                // Navigate to product details page for the order
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetailsPage(order: order),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 32),
                // Delete Account Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Account'),
                  onPressed: _deleteAccount,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    double minHeight = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
        child: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusChipWithIcon(String status) {
    Color color;
    String label;
    IconData icon;
    switch (status) {
      case 'To Ship':
        color = Colors.orange;
        label = 'To Ship';
        icon = Icons.local_shipping;
        break;
      case 'To Deliver':
        color = Colors.blue;
        label = 'To Deliver';
        icon = Icons.home;
        break;
      case 'To Rate':
        color = Colors.green;
        label = 'To Rate';
        icon = Icons.star;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info_outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    bool editable, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isAddress = label.toLowerCase() == 'address';
    return Row(
      crossAxisAlignment: isAddress
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 4),
            child: Icon(icon, color: const Color(0xFF0288D1)),
          ),
        Expanded(
          child: editable
              ? TextField(
                  controller: controller,
                  keyboardType: isAddress
                      ? TextInputType.streetAddress
                      : keyboardType,
                  maxLines: isAddress ? 2 : 1,
                  style: const TextStyle(
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    hintText: isAddress ? 'Enter your full address' : null,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                )
              : Text(
                  (controller.text.isEmpty ||
                              controller.text ==
                                  '123 Main St, City, Country') &&
                          isAddress
                      ? 'No address'
                      : controller.text,
                  style: TextStyle(
                    color:
                        (controller.text.isEmpty ||
                                controller.text ==
                                    '123 Main St, City, Country') &&
                            isAddress
                        ? Colors.red
                        : const Color(0xFF003366),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ),
      ],
    );
  }
}
