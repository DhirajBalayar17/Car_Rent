import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_new/app/di/di.dart';
import 'package:my_new/app/shared_prefs/token_shared_prefs.dart';
import 'package:my_new/features/auth/presentation/view/login_page_view.dart';
import 'package:my_new/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:my_new/features/products/presentation/view_model/products/products_cubit.dart';
import 'package:my_new/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:my_new/view/bottom_view/search.dart';

import '../../cart/presentation/view/cart_page.dart';
import '../../profile/presentation/view/profile_page.dart';
import 'view_model/cubit/home_cubit.dart';

class DashboardPageView extends StatelessWidget {
  DashboardPageView({super.key});

  final List<Widget> lstBottomScreen = [
    const Search(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HomeCubit>()),
        BlocProvider(
            create: (context) => getIt<ProductsCubit>()..loadProducts()),
        BlocProvider(create: (context) => getIt<CartCubit>()..getCart()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()..getProfile()),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final int selectedIndex =
              context.watch<HomeCubit>().state.selectedIndex;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Car Rental'),
              centerTitle: true,
              backgroundColor: const Color(0xFFB3E5FC),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    getIt<Dio>().options.headers.remove('Authorization');
                    getIt<TokenSharedPrefs>().clearToken();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
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
              child: IndexedStack(
                index: selectedIndex,
                children: lstBottomScreen,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Booking',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              backgroundColor: Colors.blueAccent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black,
              currentIndex: selectedIndex,
              onTap: context.read<HomeCubit>().changeIndex,
            ),
          );
        },
      ),
    );
  }
}
