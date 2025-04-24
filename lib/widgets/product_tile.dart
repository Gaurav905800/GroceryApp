import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/models/cart_model.dart';
import 'package:grocery_app/state/cart_provider.dart';
import 'package:grocery_app/state/favorite_provider.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final double price;
  final double discountedPrice;
  final int id;
  final void Function()? onPressed;

  const ProductTile({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.discountedPrice,
    required this.id,
    this.onPressed,
    required void Function(int id) onFavoriteToggled,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _isBought = false;
  final TextEditingController _quantityController =
      TextEditingController(text: '1');

  void _handleBuyPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter Quantity',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      int currentQuantity = int.parse(_quantityController.text);
                      if (currentQuantity > 1) {
                        _quantityController.text =
                            (currentQuantity - 1).toString();
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      int currentQuantity = int.parse(_quantityController.text);
                      _quantityController.text =
                          (currentQuantity + 1).toString();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff14213d),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    int quantity = int.parse(_quantityController.text);
                    // Add to cart
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(
                      CartItem(
                        id: widget.id,
                        title: widget.title,
                        price: widget.price,
                        image: widget.image,
                        quantity: quantity,
                      ),
                    );
                    setState(() {
                      _isBought = true;
                    });
                    Future.delayed(const Duration(seconds: 5), () {
                      setState(() {
                        _isBought = false;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add to Cart',
                    style: GoogleFonts.lexend(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 227, 225, 219),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        widget.image,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(
                          favoriteProvider.isFavorite(widget.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            favoriteProvider.toggleFavorite(widget.id, context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.description,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.price}',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xff14213d),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              onPressed: _handleBuyPressed,
                              icon: Icon(
                                _isBought
                                    ? Icons.check
                                    : Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
