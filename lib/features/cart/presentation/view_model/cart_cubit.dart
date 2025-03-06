import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_new/features/cart/data/models/add_cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_request.dart';
import 'package:my_new/features/cart/domain/entities/cart_items.dart';
import 'package:my_new/features/cart/domain/usecases/fetch_cart.dart';
import 'package:my_new/features/cart/domain/usecases/update_cart.dart';

import '../../data/models/update_cart_request.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/add_cart.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final FetchCart fetchCart;
  final AddCart addCart;
  final UpdateCart updateCart;

  CartCubit(
    this.addCart,
    this.fetchCart,
    this.updateCart,
  ) : super(CartLoading());

  Future<void> getCart() async {
    final res = await fetchCart(CartRequest());

    res.fold(
      (l) => emit(CartError(l.message)),
      (r) => emit(CartLoaded(r.cart, r.cartItems)),
    );
  }

  Future<void> addNewCart(String cartId) async {
    EasyLoading.show(status: 'Adding to cart');

    final res = await addCart(AddCartRequest(item: cartId, quantity: 1));

    res.fold(
      (l) => emit(CartError(l.message)),
      (r) => getCart(),
    );

    EasyLoading.dismiss();
  }

  Future<void> addToCart(String cartId) async {
    EasyLoading.show(status: 'Adding to cart');

    final res =
        await updateCart(UpdateCartRequest(cartitem: cartId, quantity: 1));

    res.fold(
      (l) => emit(CartError(l.message)),
      (r) => getCart(),
    );

    EasyLoading.dismiss();
  }

  Future<void> removeFromCart(String cartId) async {
    if (state is! CartLoaded) return;

    EasyLoading.show(status: 'Removing from cart');

    final res =
        await updateCart(UpdateCartRequest(cartitem: cartId, quantity: -1));

    res.fold(
      (l) => emit(CartError(l.message)),
      (r) => getCart(),
    );
    EasyLoading.dismiss();
  }

  Future<void> removeAll(BuildContext context, String cartId) async {
    if (state is! CartLoaded) return;

    final toRemoveAll = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove all from cart'),
        content: Text('Are you sure you want to remove all from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (toRemoveAll == null || !toRemoveAll) return;

    final currentState = state as CartLoaded;
    EasyLoading.show(status: 'Removing cart');

    final cartItem =
        currentState.cartItems.firstWhere((element) => element.id == cartId);
    final res = await updateCart(UpdateCartRequest(
        cartitem: cartItem.id, quantity: -1 * cartItem.quantity));

    res.fold(
      (l) => emit(CartError(l.message)),
      (r) => getCart(),
    );

    EasyLoading.dismiss();
  }
}
