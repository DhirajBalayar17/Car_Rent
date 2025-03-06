class CartItemData {
  final String id;
  final CartItem item;
  final num price;
  final int quantity;

  CartItemData({
    required this.id,
    required this.item,
    required this.price,
    required this.quantity,
  });

  CartItemData copyWith({
    String? id,
    CartItem? item,
    num? price,
    int? quantity,
  }) {
    return CartItemData(
      id: id ?? this.id,
      item: item ?? this.item,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      id: json['_id'],
      item: CartItem.fromJson(json['item']),
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final String sku;
  final List<String> images;
  final num price;

  CartItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.images,
    required this.price,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? sku,
    List<String>? images,
    num? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      images: images ?? this.images,
      price: price ?? this.price,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      name: json['name'] ?? "waht",
      sku: json['sku'],
      images: List<String>.from(json['images']),
      price: json['price'],
    );
  }
}
