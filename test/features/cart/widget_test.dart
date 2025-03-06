import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:my_new/features/cart/domain/entities/cart.dart';
import 'package:my_new/features/cart/domain/entities/cart_items.dart';
import 'package:my_new/features/cart/presentation/view/cart_page.dart';
import 'package:my_new/features/cart/presentation/view_model/cart_cubit.dart';

// Generate mock classes
@GenerateMocks([CartCubit])
import 'widget_test.mocks.dart';

void main() {
  late MockCartCubit mockCartCubit;

  final testCart = Cart(
    id: '1',
    total: 100.0,
    discount: 10.0,
    grandTotal: 90.0,
    cartNo: 12,
    userId: '123123123',
    status: 'active',
  );

  final testCartItems = [
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
  ];

  setUp(() {
    mockCartCubit = MockCartCubit();
    when(mockCartCubit.stream).thenAnswer((_) => Stream<CartState>.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<CartCubit>.value(
        value: mockCartCubit,
        child: const CartPage(),
      ),
    );
  }

  testWidgets('Shows loading indicator when state is CartLoading', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows error message when state is CartError', (WidgetTester tester) async {
    const errorMessage = 'Failed to load cart';
    when(mockCartCubit.state).thenReturn(CartError(errorMessage));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Shows empty cart message when cart is empty', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, []));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('Shows cart items when cart is not empty', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, testCartItems));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Food'), findsOneWidget);
    expect(find.text('Rs. 50.0'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // Quantity
  });

  testWidgets('Calls addToCart when add button is pressed', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, testCartItems));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    verify(mockCartCubit.addToCart('1')).called(1);
  });

  testWidgets('Calls removeFromCart when remove button is pressed', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, testCartItems));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    verify(mockCartCubit.removeFromCart('1')).called(1);
  });

  testWidgets('Shows correct bill summary', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, testCartItems));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Rs. 100.0'), findsOneWidget); // Subtotal
    expect(find.text('Rs. 10.0'), findsOneWidget); // Discount
    expect(find.text('Rs. 90.0'), findsOneWidget); // Grand Total
  });

  testWidgets('Shows checkout button', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, testCartItems));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Handles image loading errors correctly', (WidgetTester tester) async {
    when(mockCartCubit.state).thenReturn(CartLoaded(testCart, testCartItems));

    await tester.pumpWidget(createWidgetUnderTest());

    // Find the Image widget that uses network image
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    // Find the error builder widget when image fails to load
    // Since network images won't load in tests, the error builder should be called
    await tester.pump(); // Allow the image to "fail" loading

    // Testing that error builder creates the container with icon
    expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
  });
}
