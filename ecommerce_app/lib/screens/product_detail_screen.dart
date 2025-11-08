import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import './product_review_screen.dart'; // Import the restored review screen


// 1. Change StatelessWidget to StatefulWidget
class ProductDetailScreen extends StatefulWidget {

  final Map<String, dynamic> productData;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productData,
    required this.productId,
  });

  @override
  // 2. Create the State class
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

// 3. Rename the main class to _ProductDetailScreenState and extend State
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Color constants for consistency
  static const Color kAccentOrange = Color(0xFFFF7043);
  static const Color kDarkGray = Color(0xFF2A3440);
  static const Color kWhite = Color(0xFFF8FAFC);
  static const Color kLightGray = Color(0xFFDCE0E3);

  // Available sizes for this product (static list for now)
  final List<String> _availableSizes = ['S', 'M', 'L', 'XL'];

  // --- SUBMITTED REVIEWS DATA (MUTABLE, LOCAL) ---
  // This list will hold newly submitted reviews temporarily.
  List<Map<String, dynamic>> _submittedReviews = [];
  // --- END SUBMITTED REVIEWS DATA ---

  // HARDCODED USER ID for the button to function without Firebase/Auth
  final String _userId = 'MOCK-USER-1234';


  // 4. ADD OUR NEW STATE VARIABLE FOR QUANTITY
  int _quantity = 1;
  // NEW STATE VARIABLE for selected size, defaulting to the first available size
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    // Initialize selected size to the first item in the list
    _selectedSize = _availableSizes.first;
  }

  // Firebase initialization and cleanup methods have been removed.

  // 1. ADD THIS FUNCTION
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // 2. ADD THIS FUNCTION
  void _decrementQuantity() {
    // We don't want to go below 1
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  // handle size selection
  void _updateSelectedSize(String? newSize) {
    if (newSize != null) {
      setState(() {
        _selectedSize = newSize;
      });
    }
  }

  // NEW: Navigation function to the review screen
  void _navigateToReviewScreen(BuildContext context) async { // ADDED 'async'
    // Await the result from the review screen. The expected return type is Map<String, dynamic>?
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductReviewScreen(
          userId: _userId, // Pass the hardcoded user ID
          productName: widget.productData['name'],
          productId: widget.productId,
        ),
      ),
    );

    // FIX: Safely check if the result is a Map and if it contains the required keys.
    if (result != null && result is Map && result.containsKey('rating') && result.containsKey('comment')) {
      final newReview = result as Map<String, dynamic>; // Cast safely
      setState(() {
        // Add the new review to our local list and display it
        _submittedReviews.insert(0, newReview); // Insert at the start to show newest first
      });
    }
  }

  // Helper to build the star rating icons for display
  Widget _buildStarRatingDisplay(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: kAccentOrange, size: 18);
        } else if (index < rating && rating % 1 != 0) {
          return Icon(Icons.star_half, color: kAccentOrange, size: 18);
        } else {
          return Icon(Icons.star_border, color: kAccentOrange, size: 18);
        }
      }),
    );
  }

  // Helper to build a single review tile
  Widget _buildReviewTile(Map<String, dynamic> review) {
    // Ensure rating is treated as a double for display
    final rating = review['rating'] is int ? (review['rating'] as int).toDouble() : review['rating'] as double;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['user']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kDarkGray),
              ),
              _buildStarRatingDisplay(rating),
            ],
          ),
          const SizedBox(height: 4),
          // This is the user's comment/written review
          Text(
            review['comment']!,
            style: const TextStyle(fontSize: 14, height: 1.4, color: kDarkGray),
          ),
          const Divider(color: kLightGray),
        ],
      ),
    );
  }

  // The main review section widget now uses the mutable list
  Widget _buildReviewsSection() {
    final reviews = _submittedReviews;

    if (reviews.isEmpty) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "No reviews yet.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: kDarkGray),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }

    // Calculate average rating
    // NOTE: This calculation path is now reachable when reviews are added.
    final double totalRating = reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b).toDouble();
    final double averageRating = totalRating / reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Divider(thickness: 1, color: kLightGray),
        const SizedBox(height: 10),

        Text(
          'Customer Reviews',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: kDarkGray, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Average Rating Summary
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildStarRatingDisplay(averageRating),
            const SizedBox(width: 8),
            Text(
              '${averageRating.toStringAsFixed(1)} out of 5 (${reviews.length} ratings)',
              style: const TextStyle(fontSize: 16, color: kDarkGray),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // List of Individual Reviews
        ...reviews.map((review) => _buildReviewTile(review)).toList(),
      ],
    );
  }


  // 5. The build method will go inside here
  @override
  Widget build(BuildContext context) {
    final String name = widget.productData['name'];
    final String description = widget.productData['description'];
    final String imageUrl = widget.productData['imageUrl'];
    final double price = widget.productData['price'];

    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: kDarkGray, // dark gray
        foregroundColor: kWhite, // white text
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              height: 300,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(height: 300, child: Center(child: Icon(Icons.broken_image, size: 100)));
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kDarkGray)),
                  const SizedBox(height: 8),
                  Text(
                    '₱${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      // Price color set to the warm orange
                      color: kAccentOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1, color: kLightGray),
                  const SizedBox(height: 16),
                  Text('About this item', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: kDarkGray)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 16, height: 1.5, color: kDarkGray)),
                  const SizedBox(height: 30),

                  // NEW: Write a Review Button
                  OutlinedButton.icon(
                    onPressed: () => _navigateToReviewScreen(context),
                    icon: const Icon(Icons.rate_review),
                    label: const Text('Write a Review'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDarkGray,
                      side: const BorderSide(color: kDarkGray),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Customer Reviews Display Section (now uses mock data)
                  _buildReviewsSection(),

                  const SizedBox(height: 30),

                  // BAGO: Size Selection Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Size:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkGray),
                      ),

                      // NEW: Dropdown Button for size
                      DropdownButton<String>(
                        value: _selectedSize,
                        items: _availableSizes.map((String size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Text(size, style: const TextStyle(fontSize: 18, color: kDarkGray)),
                          );
                        }).toList(),
                        onChanged: _updateSelectedSize,
                        dropdownColor: kWhite, // white
                        style: const TextStyle(fontSize: 18),
                        icon: const Icon(Icons.arrow_drop_down, color: kDarkGray),
                        underline: Container(
                          height: 2,
                          color: kDarkGray, // warm orange underline
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),


                  // 4. --- QUANTITY PICKER SECTION ---
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 5. DECREMENT BUTTON
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        onPressed: _decrementQuantity,
                        style: IconButton.styleFrom(
                          backgroundColor: kLightGray, // light gray
                          foregroundColor: kDarkGray, // dark gray
                        ),
                      ),

                      // 6. QUANTITY DISPLAY
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '$_quantity', // 7. Display our state variable
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkGray),
                        ),
                      ),

                      // 8. INCREMENT BUTTON
                      IconButton.filled(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementQuantity,
                        style: IconButton.styleFrom(
                          backgroundColor: kDarkGray, // dark gray
                          foregroundColor: kWhite, // white
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // --- END OF QUANTITY PICKER SECTION ---

                  // 9. Find your "Add to Cart" button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Check if a size is selected
                      if (_selectedSize == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a size.'),
                            duration: Duration(seconds: 2),
                            backgroundColor: kAccentOrange,
                          ),
                        );
                        return;
                      }

                      // 10. --- UPDATED ADD TO CART LOGIC ---
                      cart.addItem(
                        // Create a unique ID combining product ID and size
                        '${widget.productId}_$_selectedSize',
                        '$name ($_selectedSize)', // Include size in the display name
                        price,
                        _quantity, // Pass the selected quantity
                      );

                      // 13. Update the SnackBar message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $_quantity x $name (Size: $_selectedSize) to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDarkGray, // dark gray
                      foregroundColor: kWhite, // white
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}