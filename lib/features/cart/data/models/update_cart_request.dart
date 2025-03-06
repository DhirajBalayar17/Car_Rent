class UpdateCartRequest {
  final String cartitem;
  final int quantity;

  UpdateCartRequest({
    required this.cartitem,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'cartitem': cartitem,
      'quantity': quantity,
    };
  }

  @override
  String toString() => 'UpdateCartRequest(cartitem: $cartitem, quantity: $quantity)';
}
