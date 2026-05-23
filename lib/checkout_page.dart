import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'order_success_page.dart';
import 'payment_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isProcessing = false;
  String _paymentMethod = 'Card'; // 'Card' or 'COD'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = Provider.of<AuthProvider>(context, listen: false).userData;
      if (userData != null) {
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _proceedToPayment() async {
    if (_formKey.currentState!.validate()) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            amount: cartProvider.totalPrice,
            onPaymentSuccess: () async {
              Navigator.pop(context); // Close Payment Page
              
              setState(() {
                _isProcessing = true;
              });

              try {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                
                // Prepare order data
                final Map<String, dynamic> orderData = {
                  'customerId': authProvider.user?.uid ?? 'guest',
                  'customer': {
                    'name': _nameController.text.trim(),
                    'email': _emailController.text.trim(),
                    'phone': _phoneController.text.trim(),
                    'address': _addressController.text.trim(),
                  },
                  'items': cartProvider.items.map((item) => {
                    'productId': item.product.id,
                    'name': item.product.name,
                    'price': item.product.price,
                    'quantity': item.quantity,
                  }).toList(),
                  'totalPrice': cartProvider.totalPrice,
                  'timestamp': ServerValue.timestamp,
                  'status': 'Pending',
                  'paymentMethod': 'Credit Card',
                };

                // Push to Firebase Realtime Database
                final DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('orders').push();
                await orderRef.set(orderData);
                
                final String orderId = orderRef.key ?? 'UNKNOWN';

                cartProvider.clearCart();
                
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrderSuccessPage(orderId: orderId)),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to place order: $e')),
                  );
                  setState(() {
                    _isProcessing = false;
                  });
                }
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> _placeOrderDirectly() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // Prepare order data
        final Map<String, dynamic> orderData = {
          'customerId': authProvider.user?.uid ?? 'guest',
          'customer': {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
          },
          'items': cartProvider.items.map((item) => {
            'productId': item.product.id,
            'name': item.product.name,
            'price': item.product.price,
            'quantity': item.quantity,
          }).toList(),
          'totalPrice': cartProvider.totalPrice,
          'timestamp': ServerValue.timestamp,
          'status': 'Pending',
          'paymentMethod': 'Cash on Delivery',
        };

        // Push to Firebase Realtime Database
        final DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('orders').push();
        await orderRef.set(orderData);
        
        final String orderId = orderRef.key ?? 'UNKNOWN';

        cartProvider.clearCart();
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderSuccessPage(orderId: orderId)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order: $e')),
          );
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'CHECKOUT',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Information',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: CupertinoIcons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Phone Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: CupertinoIcons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Address Field
                _buildTextField(
                  controller: _addressController,
                  label: 'Full Shipping Address',
                  icon: CupertinoIcons.location,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your shipping address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Payment Method Selection
                Text(
                  'Payment Method',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: Text('Credit / Debit Card', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                        subtitle: Text('Secure payment via Dummy Card', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
                        value: 'Card',
                        groupValue: _paymentMethod,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        title: Text('Cash on Delivery (COD)', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                        subtitle: Text('Pay when you receive the order', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
                        value: 'COD',
                        groupValue: _paymentMethod,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Order Summary
                Text(
                  'Order Summary',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '\$${Provider.of<CartProvider>(context).totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Proceed or Place Order Button
                ElevatedButton(
                  onPressed: _isProcessing 
                      ? null 
                      : (_paymentMethod == 'Card' ? _proceedToPayment : _placeOrderDirectly),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text(
                        _paymentMethod == 'Card' ? 'PROCEED TO PAYMENT' : 'PLACE ORDER',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 16,
                        ),
                      ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.montserrat(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(color: Colors.grey),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 48.0 : 0),
          child: Icon(icon, color: Colors.grey.shade400, size: 22),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
