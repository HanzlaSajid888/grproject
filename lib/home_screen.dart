import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'category_page.dart';
import 'models/product.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME TO',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'LUXE',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'MART',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.cloud_upload, color: Colors.orangeAccent),
            tooltip: 'Upload Dummy Data to Firebase',
            onPressed: () {
              productProvider.uploadDummyDataToRTDB();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uploading data to Firebase...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.bell, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Category Circles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCircle(
                    context,
                    title: 'WATCHES',
                    color: Colors.orangeAccent,
                    icon: Icons.watch,
                    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=800',
                    products: productProvider.watches,
                  ),
                  _buildCategoryCircle(
                    context,
                    title: 'ELECTRONICS',
                    color: Colors.blueAccent,
                    icon: Icons.headphones,
                    imageUrl: 'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&q=80&w=800',
                    products: productProvider.electronics,
                  ),
                  _buildCategoryCircle(
                    context,
                    title: 'FOOTWEAR',
                    color: Colors.redAccent,
                    icon: Icons.snowshoeing,
                    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=800',
                    products: productProvider.footwear,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Promotional Card
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=800'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black54, BlendMode.darken),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SEASONAL DROP',
                        style: GoogleFonts.montserrat(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PREMIUM\nSELECTIONS',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: Text(
                          'Shop Now',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // New Arrivals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Arrivals',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'SEE ALL',
                      style: GoogleFonts.montserrat(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Products List
              SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 15),
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.newArrivals.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 160,
                      child: ProductCard(product: productProvider.newArrivals[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCircle(BuildContext context,
      {required String title, required Color color, required IconData icon, required String imageUrl, required List<Product> products}) {
    return GestureDetector(
      onTap: () {
        // Navigate to Category Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              title: title,
              imageUrl: imageUrl,
              products: products,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
