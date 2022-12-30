import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFav = false,
  });

  void _setFavValue(bool newValue) {
    isFav = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();
    final url = Uri.https('flutter-project-9d0cb-default-rtdb.firebaseio.com',
        '/products/$id.json');
    try {
      final response = await http.patch(url,
          body: json.encode(
            {
              'isFav': isFav,
            },
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
