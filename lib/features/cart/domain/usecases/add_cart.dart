import 'package:dartz/dartz.dart';
import 'package:my_new/app/usecase/usecase.dart';
import 'package:my_new/features/cart/data/models/add_cart_request.dart';

import '../../../../core/error/failure.dart';
import '../repositories/cart_repository.dart';

class AddCart implements UsecaseWithParams<bool, AddCartRequest> {
  final CartRepository repository;
  const AddCart(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddCartRequest request) async {
    try {
      final response = await repository.addToCart(request);
      return Right(response);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
