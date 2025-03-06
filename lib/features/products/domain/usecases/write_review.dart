import 'package:dartz/dartz.dart';
import 'package:my_new/features/products/data/models/review_request.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class WriteReview implements UsecaseWithParams<bool, ReviewRequest> {
  final ProductRepository repository;

  WriteReview(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReviewRequest request) async {
    try {
      final res = await repository.writeReviews(request);

      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
