class AddCartRequest {
  final String item;
  final int quantity;

  AddCartRequest({
    required this.item,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'quantity': quantity,
    };
  }

  @override
  String toString() => 'AddCartRequest(item: $item, quantity: $quantity)';
}
