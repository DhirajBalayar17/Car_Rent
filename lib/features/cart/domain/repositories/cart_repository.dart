import 'package:my_new/features/cart/data/models/cart_request.dart';
import 'package:my_new/features/cart/data/models/update_cart_request.dart';

import '../../data/models/add_cart_request.dart';
import '../../data/models/cart_response.dart';

abstract class CartRepository {
  Future<String> updateCart(UpdateCartRequest request);
  Future<bool> addToCart(AddCartRequest cartRequest);
  Future<CartData> getCart(CartRequest cartRequest);
}
