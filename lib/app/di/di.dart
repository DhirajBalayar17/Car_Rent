import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_new/app/shared_prefs/onboarding_shared_prefs.dart';
import 'package:my_new/app/shared_prefs/token_shared_prefs.dart';
import 'package:my_new/core/network/api_service.dart';
import 'package:my_new/core/network/hive_service.dart';
import 'package:my_new/features/auth/data/data_source/remote_datasource/remote_datasource.dart';
import 'package:my_new/features/auth/data/repository/auth_remote_repository.dart';
import 'package:my_new/features/auth/domain/repository/auth_repository.dart';
import 'package:my_new/features/auth/domain/use_case/login_use_case.dart';
import 'package:my_new/features/auth/domain/use_case/signup_use_case.dart';
import 'package:my_new/features/auth/presentation/view_model/login/bloc/login_bloc.dart';
import 'package:my_new/features/auth/presentation/view_model/signup/bloc/signup_bloc.dart';
import 'package:my_new/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:my_new/features/cart/domain/usecases/fetch_cart.dart';
import 'package:my_new/features/cart/domain/usecases/update_cart.dart';
import 'package:my_new/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:my_new/features/products/data/datasources/products_remote_datasource.dart';
import 'package:my_new/features/products/data/repositories/product_repository_impl.dart';
import 'package:my_new/features/products/domain/repositories/product_repository.dart';
import 'package:my_new/features/products/domain/usecases/fetch_reviews.dart';
import 'package:my_new/features/products/domain/usecases/write_review.dart';
import 'package:my_new/features/products/presentation/view_model/products/products_cubit.dart';
import 'package:my_new/features/products/presentation/view_model/reviews/reviews_cubit.dart';
import 'package:my_new/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:my_new/features/profile/domain/usecases/update_profile.dart';
import 'package:my_new/features/profile/domain/usecases/update_profile_picture.dart';
import 'package:my_new/features/splash/presentation/view_model/cubit/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/internet_checker.dart';
import '../../features/auth/data/data_source/auth_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_cart.dart';
import '../../features/cart/presentation/view_model/cart_cubit.dart';
import '../../features/products/domain/usecases/fetch_products.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/fetch_profile.dart';
import '../../features/profile/presentation/view_model/profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initLoginDependencies();
  await _initSignupDependencies();
  await _initSplashDependencies();

  await _initDashboardDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt
      .registerLazySingleton<TokenSharedPrefs>(() => TokenSharedPrefs(getIt()));
  getIt.registerLazySingleton<OnboardingSharedPrefs>(
      () => OnboardingSharedPrefs(getIt()));
}

_initApiService() {
  //remote data souce
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );

  getIt.registerLazySingleton<InternetChecker>(
      () => InternetCheckerImpl(InternetConnection.createInstance()));
}

_initSignupDependencies() async {
  // register use usecase
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt(),
    ),
  );

  //Upload image use case
  // getIt.registerLazySingleton<UploadImageUsecase>(
  //   () => UploadImageUsecase(
  //     getIt<AuthRemoteRepository>(),
  //   ),
  // );

  // getIt.registerFactory<SignupBloc>(
  //   () => SignupBloc(
  //     registerUseCase: getIt(),
  //   ),
  // );

  //Remote data source
  getIt.registerFactory<IAuthDataSource>(
      () => AuthRemoteDataSource(getIt<Dio>()));

  //Repo Remotre
  getIt.registerLazySingleton<IAuthRepository>(
      () => AuthRemoteRepository(getIt(), getIt()));

  getIt.registerFactory<SignupBloc>(
    () => SignupBloc(registerUseCase: getIt()),
  );

  //Remote data sourc
}

_initLoginDependencies() async {
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(
      dio: getIt(),
      authRepository: getIt(),
      tokenSharedPrefs: getIt(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      getIt<LoginUsecase>(),
    ),
  );
}

_initSplashDependencies() async {
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt(), getIt(), getIt(), getIt()),
  );
}

_initDashboardDependencies() async {
  getIt.registerFactory<HomeCubit>(() => HomeCubit());

  _initProductDependencies();
  _initCartDependencies();
  _initProfileDependencies();
}

_initProductDependencies() async {
  getIt.registerFactory<ProductsRemoteDatasource>(
      () => ProductsRemoteDatasourceImpl(getIt<Dio>()));

  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource: getIt()));

  getIt.registerLazySingleton<FetchProducts>(() => FetchProducts(getIt()));
  getIt.registerLazySingleton<FetchReviews>(() => FetchReviews(getIt()));
  getIt.registerLazySingleton<WriteReview>(() => WriteReview(getIt()));

  getIt.registerFactory<ProductsCubit>(() => ProductsCubit(getIt()));
  getIt.registerFactory<ReviewsCubit>(() => ReviewsCubit(getIt(), getIt()));
}

_initCartDependencies() async {
  getIt.registerFactory<CartRemoteDatasource>(
      () => CartRemoteDatasourceImpl(dio: getIt<Dio>()));

  getIt.registerFactory<CartRepository>(
      () => CartRepositoryImpl(remoteDatasource: getIt()));

  getIt.registerLazySingleton<FetchCart>(() => FetchCart(getIt()));
  getIt.registerLazySingleton<UpdateCart>(() => UpdateCart(getIt()));
  getIt.registerLazySingleton<AddCart>(() => AddCart(getIt()));

  getIt.registerFactory<CartCubit>(() => CartCubit(getIt(), getIt(), getIt()));
}

_initProfileDependencies() async {
  getIt.registerFactory<ProfileRemoteDatasource>(
      () => ProfileRemoteDatasourceImpl(getIt<Dio>()));

  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt()));

  getIt.registerLazySingleton<FetchProfile>(() => FetchProfile(getIt()));
  getIt.registerLazySingleton<UpdateProfilePicture>(
      () => UpdateProfilePicture(getIt()));
  getIt.registerLazySingleton<UpdateProfile>(() => UpdateProfile(getIt()));

  getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(getIt(), getIt(), getIt()));
}
