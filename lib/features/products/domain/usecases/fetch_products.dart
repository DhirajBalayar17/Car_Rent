import 'package:dartz/dartz.dart';
import 'package:my_new/features/products/data/models/product_request.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class FetchProducts
    implements UsecaseWithParams<List<Product>, ProductRequest> {
  final ProductRepository repository;

  FetchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(ProductRequest params) async {
    try {
      final res = await repository.getProducts(params);

      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
