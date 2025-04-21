import 'package:ecm_flutter_app/utils/Api.dart';
import 'package:flutter/material.dart';
import 'ProductDisplay.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => ProductGridState();
}

class ProductGridState extends State<ProductGrid> {
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = []; // Add filtered products list
  String _selectedCategory = 'All';
  TextEditingController searchController = TextEditingController(); // Renamed from SC for clarity

  final List<String> _categories = [
    'All',
    'Electronics',
    'Furniture',
    'Shoes',
    'Clothey'
  ];
  
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    var data = await fetchProducts();
    setState(() {
      _products = data ?? [];
      _filteredProducts = _products; // Initialize filtered products
    });
  }

  // Fixed search function
  void search() {
    String searchText = searchController.text.toLowerCase();
    
    setState(() {
      // First filter by category
      var categoryFiltered = _selectedCategory == 'All'
          ? _products
          : _products.where((product) => 
              product['category']['name'] == _selectedCategory).toList();
      
      // Then filter by search text
      _filteredProducts = searchText.isEmpty
          ? categoryFiltered
          : categoryFiltered.where((product) => 
              product['title'].toString().toLowerCase().contains(searchText)).toList();
    });
  }

  // Add category filter function
  void filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      // Apply both category and search filters
      search();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategoryFilter(),
        _buildSearchAndSort(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      "No products found",
                      style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
                    ),
                  )
                : GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductCard(product, context);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: EdgeInsets.symmetric(horizontal: 16),
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              filterByCategory(category); // Updated to use filter function
            },
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF4285F4) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Color(0xFF4285F4) : Color(0xFFE0E0E0),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Color(0xFF4285F4).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF7F8C8D),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Color(0xFFE0E0E0)),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Color(0xFF7F8C8D)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF7F8C8D)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Color(0xFF7F8C8D)),
                    onPressed: () {
                      searchController.clear();
                      search(); // Apply search when cleared
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  search(); // Apply search on every change
                },
                onSubmitted: (value) {
                  search(); // Apply search when submitted
                },
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Color(0xFFE0E0E0)),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Color(0xFF7F8C8D)),
              onPressed: () {
                // Show filter options
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product, BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDisplay(product: product),
            ),
          );
        },
        child: SizedBox(
          height: 1200,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              
                children: [
                  // Product image with wishlist
                  Stack(
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        color: Color(0xFFE8F1FF),
                        child: Image.network(
                          product['images']?[0] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.image_not_supported_outlined,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.favorite_border, size: 16),
                            color: Color(0xFF7F8C8D),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Product info
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["title"] ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${(product["price"] ?? 0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          product["description"] ?? "",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${product["title"]} added to cart'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4285F4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}