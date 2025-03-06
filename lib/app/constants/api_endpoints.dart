class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 5000);
  static const Duration receiveTimeout = Duration(seconds: 5000);

  //IP for iPhone
  static const String baseUrl = "http://localhost:8000/";

  //Auth Endpoints

  static const String login = '/users/login';
  static const String register = '/users/register';
  static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  static const String uploadImage = "/uploadImage";

  static const String category = '/category?search=&page=1&size=50';

  static const String product = '/products';
  static const String reviews = '/reviews';

  static const String cart = '/carts/my-cart';

  static const String addCart = '/carts/add';
  static const String updateItem = '/carts/add-remove-item';

  static const String profile = '/users/my-profile';
  static const String uploadPP = '/users/upload-pp';
  static const String updateProfile = '/users/update-profile';
}
