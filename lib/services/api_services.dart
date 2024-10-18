import 'dart:convert';

import 'package:grocery_app/models/grocery_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<GroceryModel?> fetchData() async {
    const url = 'https://dummyjson.com/products';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      return GroceryModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
