import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_new/app/constants/api_endpoints.dart';
import 'package:my_new/features/cart/presentation/view_model/cart_cubit.dart';

import '../../../../core/common/snackbar/shake_detector/shake_detector.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late ShakeDetector _shakeDetector;
  late String cartId;

  @override
  void initState() {
    super.initState();

    _shakeDetector = ShakeDetector(
      onShake: () => context.read<CartCubit>().removeAll(context, cartId),
    );

    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB3E5FC), Color(0xFFE3F2FD)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CartError) return Center(child: Text(state.message));

              if (state is CartLoaded) {
                if (state.cartItems.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }
                cartId = state.cartItems.first.id;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cart Page',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),

                    // Cart Items List
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.cartItems.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        itemBuilder: (context, index) {
                          final cartItem = state.cartItems[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    '${ApiEndpoints.baseUrl}/${cartItem.item.images.first}',
                                    width: 120, // Increased size
                                    height: 120, // Increased size
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 120, // Match new size
                                      height: 120, // Match new size
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                          Icons.image_not_supported,
                                          size: 50),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.item.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rs. ${cartItem.item.price}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
