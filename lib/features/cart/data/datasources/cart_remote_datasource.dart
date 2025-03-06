import 'package:dio/dio.dart';
import 'package:my_new/features/cart/data/models/cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_response.dart';
import 'package:my_new/features/cart/data/models/update_cart_request.dart';

import '../../../../app/constants/api_endpoints.dart';
import '../models/add_cart_request.dart';

abstract class CartRemoteDatasource {
  Future<CartResponse> getCart(CartRequest request);
  Future<String> updateCart(UpdateCartRequest request);
  Future<bool> addToCart(AddCartRequest request);
}

class CartRemoteDatasourceImpl implements CartRemoteDatasource {
  final Dio dio;
  const CartRemoteDatasourceImpl({required this.dio});

  @override
  Future<CartResponse> getCart(CartRequest request) async {
    try {
      final response =
          await dio.get(ApiEndpoints.cart, queryParameters: request.toJson());
      if (response.statusCode == 200) {
        return CartResponse.fromJson(response.data);
      }
      throw Exception('Failed to load cart');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> updateCart(UpdateCartRequest request) async {
    try {
      final response =
          await dio.put(ApiEndpoints.updateItem, data: request.toJson());
      if (response.statusCode == 200) return response.data['msg'];
      throw Exception('Failed to update cart');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> addToCart(AddCartRequest request) async {
    try {
      final response =
          await dio.post(ApiEndpoints.addCart, data: request.toJson());
      if (response.statusCode == 200) return response.data['success'];
      throw Exception('Failed to add to cart');
    } catch (e) {
      throw Exception(e);
    }
  }
}
