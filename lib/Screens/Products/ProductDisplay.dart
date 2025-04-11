import 'package:flutter/material.dart';
import 'package:ecm_flutter_app/Screens/Products/ProductsGrid.dart';

class ProductDisplay extends StatefulWidget {
  final dynamic product;

  const ProductDisplay({super.key, required this.product});

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  late dynamic _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product["title"])),
      body: SingleChildScrollView( // Prevents overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Product Image
              Container(
                height: 250, // Fixed height
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(_product["images"][0].isNotEmpty 
                        ? _product["images"][0] 
                        : 'https://via.placeholder.com/250'), // Fallback Image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Details
              Text(
                _product["title"],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text(
                _product["description"],
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              Text(
                "₹${_product["price"].toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green),
              ),
              const SizedBox(height: 20),

              // Add to Cart Button
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_product["title"]} added to cart!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
