import 'package:my_new/features/products/data/models/review_request.dart';
import 'package:my_new/features/products/domain/entities/review.dart';

import '../../data/models/product_request.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts(ProductRequest request);
  Future<bool> writeReviews(ReviewRequest request);
  Future<List<Review>> getReviews(String productId);
}
