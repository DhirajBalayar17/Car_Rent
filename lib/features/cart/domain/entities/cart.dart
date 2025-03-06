class Cart {
  final String id;
  final int cartNo;
  final String userId;
  final num total;
  final num discount;
  final num grandTotal;
  final String status;

  Cart({
    required this.id,
    required this.cartNo,
    required this.userId,
    required this.total,
    required this.discount,
    required this.grandTotal,
    required this.status,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      cartNo: json['cart_no'],
      userId: json['user_id']['_id'],
      total: json['total'],
      discount: json['discount'],
      grandTotal: json['grand_total'],
      status: json['status'],
    );
  }
}
