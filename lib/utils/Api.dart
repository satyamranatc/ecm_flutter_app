import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> fetchProducts() async {
  var res = await http.get(Uri.parse("https://api.escuelajs.co/api/v1/products"));

  if (res.statusCode == 200) {
    var data = jsonDecode(res.body);
    print("Products: $data");
    return data;
  } else {
    print("Failed to fetch data: ${res.statusCode}");
    return null;
  }
}
