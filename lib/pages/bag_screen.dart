import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/state/cart_provider.dart';
import 'package:provider/provider.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Your Bag'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: cartProvider.items.isEmpty
          ? Center(
              child: Text(
              'Your cart is empty',
              style: GoogleFonts.lato(
                fontStyle: FontStyle.italic,
                fontSize: 26,
              ),
            ))
          : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  leading: Image.network(item.image),
                  title: Text(item.title),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
