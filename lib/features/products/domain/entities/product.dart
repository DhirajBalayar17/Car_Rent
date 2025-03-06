import 'package:my_new/app/constants/api_endpoints.dart';

class Product {
  final String id;
  final String name;
  final String sku;
  final num calorieCount;
  final String description;
  final List<String> images;
  final Category category;
  final num price;
  final num rating;

  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.calorieCount,
    required this.description,
    required this.images,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      sku: json['sku'],
      calorieCount: json['calorie_count'],
      description: json['description'],
      images: List<String>.from(json['images'])
          .map((e) => '${ApiEndpoints.baseUrl}/$e')
          .toList(),
      category: Category.fromJson(json['category']),
      price: json['price'],
      rating: json['rating'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int v;

  const Category({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      isActive: json['is_active'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
