import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_new/app/di/di.dart';
import 'package:my_new/core/app_theme/app_theme.dart';
import 'package:my_new/features/splash/presentation/view/splash_screen_view.dart';
import 'package:my_new/features/splash/presentation/view_model/cubit/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodHub',
      theme: AppTheme.getApplicationTheme(isDark: false),
      builder: EasyLoading.init(),
      home: BlocProvider.value(
        value: getIt<SplashCubit>(),
        child: const SplashScreen(),
      ),
    );
  }
}
