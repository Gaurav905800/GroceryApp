// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/models/cart_model.dart';
import 'package:grocery_app/models/grocery_model.dart';
import 'package:grocery_app/state/cart_provider.dart';
import 'package:grocery_app/state/favorite_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Products product;

  const DetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isBought = false;
  final TextEditingController _quantityController =
      TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Timer? _timer;
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
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(
                      CartItem(
                        id: widget.product.id!,
                        title: widget.product.title!,
                        price: widget.product.price!,
                        image: widget.product.images![0],
                        quantity: quantity,
                      ),
                    );

                    setState(() {
                      _isBought = true;
                    });

                    // Schedule the delayed task
                    _timer = Timer(const Duration(seconds: 5), () {
                      if (mounted) {
                        setState(() {
                          _isBought = false;
                        });
                      }
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
    final isFavorite = favoriteProvider.isFavorite(widget.product.id!);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: isPortrait
                  ? _buildPortraitContent(context, isFavorite, favoriteProvider)
                  : _buildLandscapeContent(
                      context, isFavorite, favoriteProvider),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitContent(BuildContext context, bool isFavorite,
      FavoriteProvider favoriteProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                widget.product.thumbnail!,
                fit: BoxFit.contain,
                height: 300,
                width: double.infinity,
              ),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 27,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 27,
                  ),
                  onPressed: () {
                    setState(() {
                      favoriteProvider.toggleFavorite(
                          widget.product.id!, context);
                    });
                  },
                ),
              ),
            ],
          ),
          _buildProductDetails(),
        ],
      ),
    );
  }

  Widget _buildLandscapeContent(BuildContext context, bool isFavorite,
      FavoriteProvider favoriteProvider) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              Image.network(
                widget.product.thumbnail!,
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
              ),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 27,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 27,
                  ),
                  onPressed: () {
                    setState(() {
                      favoriteProvider.toggleFavorite(
                          widget.product.id!, context);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: _buildProductDetails(),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.product.title!,
                    maxLines: 2,
                    softWrap: true,
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text(
                        widget.product.rating!.toString(),
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (widget.product.brand != null &&
                widget.product.brand!.isNotEmpty)
              Row(
                children: [
                  const Text('by '),
                  Text(widget.product.brand!),
                ],
              ),
            const SizedBox(height: 14),
            Text(
              widget.product.description!,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dimensions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.product.dimensions != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.product.dimensions!.width != null)
                    Text(
                      'Width: ${widget.product.dimensions!.width} cm',
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Colors.grey.shade700),
                    ),
                  if (widget.product.dimensions!.height != null)
                    Text(
                      'Height: ${widget.product.dimensions!.height} cm',
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Colors.grey.shade700),
                    ),
                  if (widget.product.dimensions!.depth != null)
                    Text(
                      'Depth: ${widget.product.dimensions!.depth} cm',
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Colors.grey.shade700),
                    ),
                ],
              ),
            const SizedBox(height: 10),
            if (widget.product.weight != null)
              Text(
                'Weight: ${widget.product.weight} kg',
                style:
                    GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          top: 15,
          left: 25,
          right: 25,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${widget.product.price!.toStringAsFixed(2)}',
              style: GoogleFonts.lato(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xff14213d),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: InkWell(
                  onTap: _handleBuyPressed,
                  child: Text(
                    'Buy now',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
