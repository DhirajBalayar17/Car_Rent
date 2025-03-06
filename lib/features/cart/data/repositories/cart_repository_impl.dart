import 'package:my_new/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:my_new/features/cart/data/models/add_cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_response.dart';
import 'package:my_new/features/cart/data/models/update_cart_request.dart';

import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource remoteDatasource;

  CartRepositoryImpl({required this.remoteDatasource});

  @override
  Future<CartData> getCart(CartRequest cartRequest) async {
    final res = await remoteDatasource.getCart(cartRequest);

    return res.data;
  }

  @override
  Future<String> updateCart(UpdateCartRequest request) {
    return remoteDatasource.updateCart(request);
  }

  @override
  Future<bool> addToCart(AddCartRequest cartRequest) {
    return remoteDatasource.addToCart(cartRequest);
  }
}
