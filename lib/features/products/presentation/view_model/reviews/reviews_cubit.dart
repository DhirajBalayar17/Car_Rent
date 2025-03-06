import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_new/core/common/snackbar/my_snackbar.dart';
import 'package:my_new/features/products/data/models/review_request.dart';
import 'package:my_new/features/products/domain/entities/review.dart';
import 'package:my_new/features/products/domain/usecases/fetch_reviews.dart';
import 'package:my_new/features/products/domain/usecases/write_review.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final FetchReviews fetchReviews;
  final WriteReview writeReview;
  ReviewsCubit(this.fetchReviews, this.writeReview)
      : super(const ReviewsLoading());

  Future<void> loadReviews(String productId) async {
    emit(const ReviewsLoading());

    final result = await fetchReviews(productId);
    result.fold(
      (l) => emit(ReviewsError(l.message)),
      (r) => emit(ReviewsLoaded(reviews: r)),
    );
  }

  Future<void> addReview(BuildContext context, String productId, String message,
      int rating) async {
    emit(const ReviewsLoading());

    final result = await writeReview(
        ReviewRequest(product: productId, message: message, rating: rating));
    result.fold(
      (l) => showMySnackBar(context: context, message: l.message),
      (r) {
        showMySnackBar(context: context, message: 'Review added successfully');
        loadReviews(productId);
      },
    );
  }
}
