class ReviewRequest {
  final String product;
  final String message;
  final int rating;
  const ReviewRequest({
    required this.product,
    required this.message,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'message': message,
      'rating': rating,
    };
  }
}
