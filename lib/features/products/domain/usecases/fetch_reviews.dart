import 'package:dartz/dartz.dart';

import 'package:my_new/features/products/domain/entities/review.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class FetchReviews implements UsecaseWithParams<List<Review>, String> {
  final ProductRepository repository;

  FetchReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(String productId) async {
    try {
      final res = await repository.getReviews(productId);

      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
