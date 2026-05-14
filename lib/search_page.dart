import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final searchResults = productProvider.searchProducts(_searchQuery);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Search Input
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: GoogleFonts.montserrat(),
                decoration: InputDecoration(
                  hintText: 'Search pieces, categories...',
                  hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${searchResults.length} treasures discovered',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Filter Button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16, color: Colors.black54),
                label: Text(
                  'Filter',
                  style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _searchQuery.isEmpty ? 'Search for pieces' : 'No results found',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isEmpty 
                                ? 'Discover curated collections and exclusive drops.' 
                                : 'Perhaps try different keywords or browse\nour curated collections.',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: searchResults[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
