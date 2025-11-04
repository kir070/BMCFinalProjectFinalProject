// // import 'package:flutter/material.dart';
// //
// // // A simple StatelessWidget to show product info
// // class ProductCard extends StatelessWidget {
// //   final String productName;
// //   final double price;
// //   final String imageUrl;
// //
// //   const ProductCard({
// //     super.key,
// //     required this.productName,
// //     required this.price,
// //     required this.imageUrl,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       elevation: 3,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           Expanded(
// //             child: Image.network(
// //               imageUrl,
// //               fit: BoxFit.cover,
// //               loadingBuilder: (context, child, loadingProgress) {
// //                 if (loadingProgress == null) return child;
// //                 return const Center(child: CircularProgressIndicator());
// //               },
// //               errorBuilder: (context, error, stackTrace) {
// //                 return const Center(
// //                   child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   productName,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16,
// //                   ),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   '₱${price.toStringAsFixed(2)}',
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey[700],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../screens/product_detail_screen.dart';
//
// class ProductCard extends StatelessWidget {
//   final String productName;
//   final double price;
//   final String imageUrl;
//   final String description; // Add this field
//
//   const ProductCard({
//     super.key,
//     required this.productName,
//     required this.price,
//     required this.imageUrl,
//     required this.description, // Add in constructor
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ProductDetailScreen(
//               productName: productName,
//               description: description,
//               price: price,
//               imageUrl: imageUrl,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 3,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return const Center(child: CircularProgressIndicator());
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Center(
//                     child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     productName,
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '₱${price.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final String imageUrl;
  final VoidCallback onTap; // Tap callback

  const ProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.onTap, // Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Ripple effect when tapped
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product image
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product price
                  Text(
                    '₱${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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

