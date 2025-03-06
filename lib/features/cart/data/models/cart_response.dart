import 'package:my_new/features/cart/domain/entities/cart.dart';

import '../../domain/entities/cart_items.dart';

class CartResponse {
  CartResponse({
    required this.success,
    required this.msg,
    required this.data,
  });

  final bool success;
  final String msg;
  final CartData data;

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        success: json["success"],
        msg: json["msg"],
        data: CartData.fromJson(json["data"]),
      );
}

class CartData {
  CartData({
    required this.cart,
    required this.cartItems,
  });

  final Cart cart;
  final List<CartItemData> cartItems;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        cart: Cart.fromJson(json["cart"]),
        cartItems: List<CartItemData>.from(
            json["cartItems"].map((x) => CartItemData.fromJson(x))),
      );
}
