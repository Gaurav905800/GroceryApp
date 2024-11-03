import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/models/grocery_model.dart';
import 'package:grocery_app/state/favorite_provider.dart'; // Assuming you're using Provider for favorite management
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
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(widget.product.id!);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
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
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to previous page
                    },
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
                        favoriteProvider.toggleFavorite(widget.product.id!);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expanded details section
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product title and rating row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.product.title!,
                                textDirection: TextDirection.ltr,
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
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.product.rating!.toString(),
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold),
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
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              if (widget.product.dimensions!.height != null)
                                Text(
                                  'Height: ${widget.product.dimensions!.height} cm',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              if (widget.product.dimensions!.depth != null)
                                Text(
                                  'Depth: ${widget.product.dimensions!.depth} cm',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(height: 10),

                        // Weight, if available
                        if (widget.product.weight != null)
                          Text(
                            'Weight: ${widget.product.weight} kg',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xff14213d),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'Buy now',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
