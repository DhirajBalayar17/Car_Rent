class CartRequest {
  final int page;
  final int limit;

  CartRequest({
    this.page = 1,
    this.limit = 50,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
    };
  }

  @override
  String toString() => 'CartRequest(page: $page, limit: $limit)';
}
