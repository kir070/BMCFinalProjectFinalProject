import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/payment_screen.dart'; // 1. Import PaymentScreen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 2. We now need a StatefulWidget to manage item selection state
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

// Assuming CartItem in CartProvider has properties: id (String), name (String), price (double), quantity (int)
class _CartScreenState extends State<CartScreen> {
  // State to track which items are selected (Key: Item ID, Value: isChecked)
  // We initialize everything to 'true' by default.
  Map<String, bool> _selectedItems = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We use didChangeDependencies to safely access the Provider context
    final cart = Provider.of<CartProvider>(context, listen: false);
    _initializeSelection(cart.items);
  }

  // Initializes or updates the selection map when cart items change
  void _initializeSelection(List<dynamic> currentItems) {
    final newSelected = <String, bool>{};

    for (var item in currentItems) {
      // Keep existing selection state, otherwise default to true (selected)
      newSelected[item.id] = _selectedItems[item.id] ?? true;
    }

    // Update the state map, automatically discarding IDs that no longer exist in the cart
    _selectedItems = newSelected;
  }

  // Calculates totals only for selected items
  ({double subtotal, double vat, double total}) _calculateSelectedTotals(
      List<dynamic> items) {
    double selectedSubtotal = 0.0;

    for (var item in items) {
      // Check if the item is selected in our state map
      if (_selectedItems[item.id] == true) {
        selectedSubtotal += item.price * item.quantity;
      }
    }

    const vatRate = 0.12;
    final selectedVat = selectedSubtotal * vatRate;
    final selectedTotal = selectedSubtotal + selectedVat;

    return (subtotal: selectedSubtotal, vat: selectedVat, total: selectedTotal);
  }

  // Toggles the selection status and updates the UI
  void _toggleSelection(String itemId, bool? value) {
    if (value != null) {
      setState(() {
        _selectedItems[itemId] = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. We listen: true, so the list and total update. Note: totals are now calculated selectively.
    final cart = Provider.of<CartProvider>(context);

    // Calculated totals for selected items
    final totals = _calculateSelectedTotals(cart.items);
    final isAnyItemSelected = _selectedItems.containsValue(true);

    // If cart items change while the screen is open, re-initialize selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cart.items.length != _selectedItems.length) {
        _initializeSelection(cart.items);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          // 4. The ListView is the same as before (now with checkboxes in the item list)
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty.'))
                : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(cartItem.name[0]),
                  ),
                  title: Text(cartItem.name),
                  subtitle: Text('Qty: ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // This checkbox is added for the selective checkout feature
                      Checkbox(
                        value: _selectedItems[cartItem.id] ?? true,
                        onChanged: (value) => _toggleSelection(cartItem.id, value),
                        activeColor: Color(0xFFFF7043),
                      ),
                      const SizedBox(width: 8),
                      Text(
                          '₱${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cart.removeItem(cartItem.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 5. --- THIS IS OUR NEW PRICE BREAKDOWN CARD (from Module 15) ---
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Selected Subtotal:', style: TextStyle(fontSize: 16)),
                      // Value updated to use the calculated selected total
                      Text('₱${totals.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('VAT (12%):', style: TextStyle(fontSize: 16)),
                      // Value updated to use the calculated selected VAT
                      Text('₱${totals.vat.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total to Order:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        // Value updated to use the calculated selected total
                        '₱${totals.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:const Color(0xFFFF7043),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. --- THIS IS THE MODIFIED BUTTON ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              // 7. Disable if NO items are selected, otherwise navigate
              onPressed: isAnyItemSelected ? () {
                // 8. Navigate to our new PaymentScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      // 9. Pass the final VAT-inclusive total for the SELECTED items
                      totalAmount: totals.total,
                    ),
                  ),
                );
              } : null,
              // 10. No more spinner!
              child: Text(
                isAnyItemSelected
                    ? 'Checkout Selected Items (₱${totals.total.toStringAsFixed(2)})'
                    : 'Select Items to Checkout',
              ),
            ),
          ),
        ],
      ),
    );
  }
}