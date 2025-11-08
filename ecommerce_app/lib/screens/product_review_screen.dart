import 'package:flutter/material.dart';

class ProductReviewScreen extends StatefulWidget {
  final String productName;
  final String productId;
  final String userId; // Required for the constructor, even if not used

  const ProductReviewScreen({
    super.key,
    required this.userId,
    required this.productName,
    required this.productId,
  });

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  int _rating = 0;
  bool _isLoading = false; // NEW: State to manage button loading
  final TextEditingController _reviewController = TextEditingController();

  // Color constants
  static const Color kAccentOrange = Color(0xFFFF7043);
  static const Color kDarkGray = Color(0xFF2A3440);
  static const Color kWhite = Color(0xFFF8FAFC);
  static const Color kLightGray = Color(0xFFDCE0E3); // Added for button styling

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _rateProduct(int newRating) {
    setState(() {
      _rating = newRating;
    });
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        // The star is "filled" if its index (1-5) is less than or equal to the current rating
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: kAccentOrange,
            size: 36,
          ),
          onPressed: _isLoading ? null : () => _rateProduct(index + 1), // Disabled when loading
        );
      }),
    );
  }

  void _submitReview() async {
    if (_rating == 0 || _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating and write a review.')),
      );
      return;
    }

    // 1. RE-ADDED: Prepare the data to be returned
    final reviewData = {
      // Use the MOCK-USER ID passed from the detail screen
      'user': 'User ${widget.userId.substring(5, 10)}',
      'rating': _rating,
      'comment': _reviewController.text,
    };

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    // Simulate saving data with a 2-second delay
    await Future.delayed(const Duration(seconds: 2));

    // Reset loading state
    setState(() {
      _isLoading = false;
    });

    // 2. Updated success message to reflect local display
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted and displayed locally!'),
        backgroundColor: Colors.green,
      ),
    );

    // 3. FIX: Navigate back to the product detail screen, passing the review data as the result
    Navigator.of(context).pop(reviewData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Review'),
        backgroundColor: kDarkGray,
        foregroundColor: kWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Context
            Text(
              'Reviewing: ${widget.productName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkGray),
            ),
            Text(
              'User ID: ${widget.userId}',
              style: const TextStyle(fontSize: 14, color: kDarkGray),
            ),
            const SizedBox(height: 20),

            // Star Rating Section
            const Text(
              'Your Rating:',
              style: TextStyle(fontSize: 18, color: kDarkGray),
            ),
            const SizedBox(height: 8),
            Center(
              child: _buildStarRating(),
            ),
            const SizedBox(height: 30),

            // Review Text Input
            const Text(
              'Your Review:',
              style: TextStyle(fontSize: 18, color: kDarkGray),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reviewController,
              enabled: !_isLoading, // Disable input when loading
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your experience with the product...',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: kLightGray),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kAccentOrange, width: 2.0),
                ),
                fillColor: _isLoading ? kLightGray : kWhite,
                filled: true,
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button with Loading Indicator
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submitReview, // Disable when loading
              icon: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: kWhite,
                  strokeWidth: 3,
                ),
              )
                  : const Icon(Icons.send),
              label: Text(_isLoading ? 'Submitting...' : 'Submit Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGray,
                foregroundColor: kWhite,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // Disable button color when loading
                disabledBackgroundColor: kLightGray,
                disabledForegroundColor: kDarkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}