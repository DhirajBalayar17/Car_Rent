import 'package:dartz/dartz.dart';
import 'package:my_new/app/usecase/usecase.dart';
import 'package:my_new/features/cart/data/models/cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_response.dart';

import '../../../../core/error/failure.dart';
import '../repositories/cart_repository.dart';

class FetchCart implements UsecaseWithParams<CartData, CartRequest> {
  final CartRepository repository;
  const FetchCart(this.repository);

  @override
  Future<Either<Failure, CartData>> call(CartRequest request) async {
    try {
      final response = await repository.getCart(request);
      return Right(response);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
