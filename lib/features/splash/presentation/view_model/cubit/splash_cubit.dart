import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di/di.dart';
import '../../../../../app/shared_prefs/onboarding_shared_prefs.dart';
import '../../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../../view/onboarding_page_view.dart';
import '../../../../auth/presentation/view_model/login/bloc/login_bloc.dart';
import '../../../../home/presentation/home_view.dart';
import '../../../../home/presentation/view_model/cubit/home_cubit.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._tokenSharedPrefs, this._homeCubit, this._loginBloc,
      this._onboardingSharedPrefs)
      : super(null);

  final TokenSharedPrefs _tokenSharedPrefs;
  final OnboardingSharedPrefs _onboardingSharedPrefs;
  final LoginBloc _loginBloc;
  final HomeCubit _homeCubit;

  Future<void> checkTokenAndNavigate(BuildContext context) async {
    final onboardingResult = await _onboardingSharedPrefs.getFirstTime();
    onboardingResult.fold(
      (failure) => goToLogin(context),
      (isFirstTime) async {
        if (isFirstTime) {
          goToOnboarding(context);
        } else {
          final tokenResult = await _tokenSharedPrefs.getToken();
          tokenResult.fold(
            (failure) => goToLogin(context),
            (String? token) {
              if (token != null && token.trim().isNotEmpty) {
                getIt<Dio>().options.headers['Authorization'] = 'Bearer $token';
                goToHome(context);
              } else {
                goToLogin(context);
              }
            },
          );
        }
      },
    );
  }

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () async {
      if (context.mounted) checkTokenAndNavigate(context);
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _loginBloc,
          child: OnboardingPage(),
        ),
      ),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _homeCubit,
          child: DashboardPageView(),
        ),
      ),
    );
  }

  void goToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }
}
