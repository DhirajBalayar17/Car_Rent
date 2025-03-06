class ProductRequest {
  final int? page;
  final int? size;
  final String? price;
  final String? date;
  final String? search;

  const ProductRequest({
    this.page = 1,
    this.size = 50,
    this.price = '',
    this.date = '',
    this.search = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'size': size,
      'price': price,
      'date': date,
      'search': search,
    };
  }
}
