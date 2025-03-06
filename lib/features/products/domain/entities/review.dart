import 'package:my_new/features/profile/domain/entities/profile.dart';

class Review {
  Review({
    required this.id,
    required this.product,
    this.user,
    required this.rating,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String product;
  Profile? user;
  final int rating;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        product: json["product"],
        user: json["user"] == null ? null : Profile.fromJson(json["user"]),
        rating: json["rating"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
