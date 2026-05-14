import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'sign_in_page.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for the auth state to load or delay for splash animation
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Logo Text
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'LUXE',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'MART',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Loading Indicator (3 dots as a placeholder)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(Colors.orangeAccent),
              _buildDot(Colors.orangeAccent.withOpacity(0.5)),
              _buildDot(Colors.orangeAccent.withOpacity(0.2)),
            ],
          ),
          const Spacer(),
          // Bottom Tagline
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              'ELEVATION OF ESSENCE',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.white54,
                letterSpacing: 3.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
