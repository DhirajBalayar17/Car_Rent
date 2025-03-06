import 'package:dartz/dartz.dart';
import 'package:my_new/app/usecase/usecase.dart';
import 'package:my_new/features/cart/data/models/update_cart_request.dart';

import '../../../../core/error/failure.dart';
import '../repositories/cart_repository.dart';

class UpdateCart implements UsecaseWithParams<String, UpdateCartRequest> {
  final CartRepository repository;
  const UpdateCart(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateCartRequest request) async {
    try {
      final response = await repository.updateCart(request);
      return Right(response);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
