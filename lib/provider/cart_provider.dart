import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/photos_data.dart';

final cartNotifierProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider(ref);
});

class CartProvider extends ChangeNotifier {
  Ref ref;
  List<PhotosData> cartData = [];
  CartProvider(this.ref);
  rebuildApp() {
    notifyListeners();
  }
}
