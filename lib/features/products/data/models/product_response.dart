import '../../domain/entities/product.dart';

class ProductResponse {
  ProductResponse({
    required this.success,
    required this.msg,
    required this.data,
    required this.totalCount,
    required this.size,
    required this.page,
  });

  final bool success;
  final String msg;
  final List<Product> data;
  final int totalCount;
  final int size;
  final int page;

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        success: json["success"],
        msg: json["msg"],
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
        totalCount: json["totalCount"],
        size: json["size"],
        page: json["page"],
      );
}
