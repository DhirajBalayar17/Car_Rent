import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:my_new/app/constants/api_endpoints.dart';
import 'package:my_new/core/error/failure.dart';
import 'package:my_new/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:my_new/features/cart/data/models/add_cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_request.dart';
import 'package:my_new/features/cart/data/models/cart_response.dart';
import 'package:my_new/features/cart/data/models/update_cart_request.dart';
import 'package:my_new/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:my_new/features/cart/domain/entities/cart.dart';
import 'package:my_new/features/cart/domain/entities/cart_items.dart';
import 'package:my_new/features/cart/domain/repositories/cart_repository.dart';
import 'package:my_new/features/cart/domain/usecases/add_cart.dart';
import 'package:my_new/features/cart/domain/usecases/fetch_cart.dart';
import 'package:my_new/features/cart/domain/usecases/update_cart.dart';

// Generate mock classes
import 'unit_test.mocks.dart';

@GenerateMocks([CartRemoteDatasource, CartRepository, Dio])
void main() {
  group('CartRemoteDatasource', () {
    late MockDio mockDio;
    late CartRemoteDatasource datasource;

    setUp(() {
      mockDio = MockDio();
      datasource = CartRemoteDatasourceImpl(dio: mockDio);
    });

    test('getCart returns CartResponse when successful', () async {
      // Arrange
      final response = Response(
        data: {
          'success': true,
          'msg': 'Cart fetched successfully',
          'data': {
            'cart': {
              '_id': '1',
              'total': 100.0,
              'discount': 10.0,
              'grand_total': 90.0,
              'cart_no': 12,
              'user_id': {'_id': '123123123'},
              'status': 'active',
            },
            'cartItems': [
              {
                '_id': '1',
                'quantity': 2,
                'price': 12,
                'item': {
                  '_id': 'item1',
                  'name': 'Test Food',
                  'price': 50.0,
                  'images': ['test_image.jpg'],
                  'sku': '123',
                }
              }
            ]
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiEndpoints.cart),
      );
      when(mockDio.get(ApiEndpoints.cart, queryParameters: anyNamed('queryParameters'))).thenAnswer((_) async => response);

      // Act
      final result = await datasource.getCart(CartRequest());

      // Assert
      expect(result, isA<CartResponse>());
      expect(result.data.cart.total, 100.0);
      expect(result.data.cartItems.length, 1);
    });

    test('getCart throws Exception when API call fails', () async {
      // Arrange
      when(mockDio.get(ApiEndpoints.cart, queryParameters: anyNamed('queryParameters'))).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.cart),
        error: 'Network error',
      ));

      // Act & Assert
      expect(() => datasource.getCart(CartRequest()), throwsException);
    });

    test('updateCart returns success message when successful', () async {
      // Arrange
      final response = Response(
        data: {'msg': 'Cart updated successfully'},
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiEndpoints.updateItem),
      );
      when(mockDio.put(ApiEndpoints.updateItem, data: anyNamed('data'))).thenAnswer((_) async => response);

      // Act
      final result = await datasource.updateCart(UpdateCartRequest(cartitem: 'cart1', quantity: 1));

      // Assert
      expect(result, 'Cart updated successfully');
    });

    test('addToCart returns true when successful', () async {
      // Arrange
      final response = Response(
        data: {'success': true},
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiEndpoints.addCart),
      );
      when(mockDio.post(ApiEndpoints.addCart, data: anyNamed('data'))).thenAnswer((_) async => response);

      // Act
      final result = await datasource.addToCart(AddCartRequest(item: 'item1', quantity: 1));

      // Assert
      expect(result, true);
    });
  });

  group('CartRepository', () {
    late MockCartRemoteDatasource mockRemoteDatasource;
    late CartRepository repository;

    setUp(() {
      mockRemoteDatasource = MockCartRemoteDatasource();
      repository = CartRepositoryImpl(remoteDatasource: mockRemoteDatasource);
    });

    test('getCart returns CartData from remote datasource', () async {
      // Arrange
      final cartResponse = CartResponse(
        success: true,
        data: CartData(
          cart: Cart(
            id: '1',
            total: 100.0,
            discount: 10.0,
            grandTotal: 90.0,
            cartNo: 12,
            userId: '123123123',
            status: 'active',
          ),
          cartItems: [
            CartItemData(
              id: '1',
              price: 12,
              quantity: 2,
              item: CartItem(
                id: '1',
                name: 'Test Food',
                price: 50.0,
                images: ['assets/images/food1.jpg'],
                sku: '123',
              ),
            ),
          ],
        ),
        msg: 'Cart fetched successfully',
      );
      when(mockRemoteDatasource.getCart(any)).thenAnswer((_) async => cartResponse);

      // Act
      final result = await repository.getCart(CartRequest());

      // Assert
      expect(result, cartResponse.data);
      verify(mockRemoteDatasource.getCart(any)).called(1);
    });

    test('updateCart forwards call to remote datasource', () async {
      // Arrange
      when(mockRemoteDatasource.updateCart(any)).thenAnswer((_) async => 'Updated');

      // Act
      final result = await repository.updateCart(UpdateCartRequest(cartitem: 'cart1', quantity: 1));

      // Assert
      expect(result, 'Updated');
      verify(mockRemoteDatasource.updateCart(any)).called(1);
    });
  });

  group('Use Cases', () {
    late MockCartRepository mockRepository;
    late FetchCart fetchCartUseCase;
    late AddCart addCartUseCase;
    late UpdateCart updateCartUseCase;

    setUp(() {
      mockRepository = MockCartRepository();
      fetchCartUseCase = FetchCart(mockRepository);
      addCartUseCase = AddCart(mockRepository);
      updateCartUseCase = UpdateCart(mockRepository);
    });

    test('FetchCart returns Right<CartData> when successful', () async {
      // Arrange
      final cartData = CartData(
        cart: Cart(
          id: '1',
          total: 100.0,
          discount: 10.0,
          grandTotal: 90.0,
          cartNo: 12,
          userId: '123123123',
          status: 'active',
        ),
        cartItems: [],
      );
      when(mockRepository.getCart(any)).thenAnswer((_) async => cartData);

      // Act
      final result = await fetchCartUseCase(CartRequest());

      // Assert
      expect(result, Right<Failure, CartData>(cartData));
      verify(mockRepository.getCart(any)).called(1);
    });

    test('FetchCart returns Left<Failure> when repository throws', () async {
      // Arrange
      when(mockRepository.getCart(any)).thenThrow(Exception('Test error'));

      // Act
      final result = await fetchCartUseCase(CartRequest());

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (r) => fail('Should return a Left<Failure>'),
      );
    });

    test('AddCart returns Right<bool> when successful', () async {
      // Arrange
      when(mockRepository.addToCart(any)).thenAnswer((_) async => true);

      // Act
      final result = await addCartUseCase(AddCartRequest(item: 'item1', quantity: 1));

      // Assert
      expect(result, const Right<Failure, bool>(true));
      verify(mockRepository.addToCart(any)).called(1);
    });

    test('UpdateCart returns Right<String> when successful', () async {
      // Arrange
      when(mockRepository.updateCart(any)).thenAnswer((_) async => 'Success message');

      // Act
      final result = await updateCartUseCase(UpdateCartRequest(cartitem: 'cart1', quantity: 1));

      // Assert
      expect(result, const Right<Failure, String>('Success message'));
      verify(mockRepository.updateCart(any)).called(1);
    });
  });
}
