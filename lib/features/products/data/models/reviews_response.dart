import '../../domain/entities/review.dart';

class ReviewResponse {
  ReviewResponse({
    required this.msg,
    required this.data,
  });

  final String msg;
  final List<Review> data;

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        msg: json["msg"],
        data: List<Review>.from(json["data"].map((x) => Review.fromJson(x))),
      );
}
