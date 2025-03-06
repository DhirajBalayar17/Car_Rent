import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_new/app/usecase/usecase.dart';
import 'package:my_new/core/error/failure.dart';
import 'package:my_new/features/auth/domain/entity/auth_entity.dart';
import 'package:my_new/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String? userId;
  final String email;
  final String name;
  final String phone;
  final String password;

  const RegisterUserParams({
    this.userId,
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
  });

  //intial constructor
  const RegisterUserParams.initial({
    this.userId,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
  });

  @override
  List<Object?> get props => [userId, email, name, password, phone];
}

class RegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      userId: params.userId,
      email: params.email,
      name: params.name,
      phone: params.phone,
      password: params.password,
    );
    return repository.registerUser(authEntity);
  }
}
