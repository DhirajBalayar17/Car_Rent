import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_new/core/error/failure.dart';
import 'package:my_new/core/network/internet_checker.dart';
import 'package:my_new/features/auth/data/data_source/auth_data_source.dart';
import 'package:my_new/features/auth/domain/entity/auth_entity.dart';
import 'package:my_new/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final InternetChecker internetChecker;
  final IAuthDataSource _authRemoteDataSource;

  AuthRemoteRepository(this._authRemoteDataSource, this.internetChecker);

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    if (!await internetChecker.isConnected) return Left(NoInternetFailure());

    try {
      final student = await _authRemoteDataSource.loginUser(email, password);
      return Right(student);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, String>> registerUser(AuthEntity user) async {
    if (!await internetChecker.isConnected) return Left(NoInternetFailure());

    try {
      final res = await _authRemoteDataSource.registerUser(user);
      return Right(res);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
