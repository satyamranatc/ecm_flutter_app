void main() {
  List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Laptop',
      'price': 79999,
      'inStock': true,
    },
    {
      'id': 2,
      'name': 'Smartphone',
      'price': 29999,
      'inStock': false,
    },
    {
      'id': 3,
      'name': 'Headphones',
      'price': 1999,
      'inStock': true,
    },
    {
      'id': 4,
      'name': 'Keyboard',
      'price': 999,
      'inStock': true,
    },
  ];

  // Loop to print products that contain 'a' in their name
  for (var product in products) {
    if (product["inStock"] == false) {
      print('ID: ${product['id']}');
      print('Name: ${product['name']}');
      print('Price: ₹${product['price']}');
      print('In Stock: ${product['inStock'] ? "Yes" : "No"}');
    }
    print('-------------------------');
  }
}
