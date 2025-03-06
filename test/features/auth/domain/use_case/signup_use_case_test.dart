import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_new/core/error/failure.dart';
import 'package:my_new/features/auth/domain/entity/auth_entity.dart';
import 'package:my_new/features/auth/domain/use_case/signup_use_case.dart';

import 'login_use_case_test.dart';

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);
  });

  const registerParams = RegisterUserParams(
    userId: '1',
    email: 'test@gmail.com',
    name: 'Test User',
    phone: '1234567890',
    // image: 'test_image.png',
    password: 'test1234',
  );

  final authEntity = AuthEntity(
    userId: registerParams.userId,
    email: registerParams.email,
    name: registerParams.name,
    password: registerParams.password,
    phone: registerParams.phone,
    // image: registerParams.image,
  );

  test('should call registerUser in the repository with correct params',
      () async {
    // Arrange
    when(() => repository.registerUser(authEntity))
        .thenAnswer((_) async => const Right('Register Successfully!'));

    // Act
    final result = await useCase(registerParams);

    // Assert
    expect(result, const Right('Register Successfully!'));
    verify(() => repository.registerUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return Left(Failure) when registration fails', () async {
    // Arrange
    const failure = ApiFailure(message: 'Registration failed');
    when(() => repository.registerUser(authEntity))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await useCase(registerParams);

    // Assert
    expect(result, const Left(failure));
    verify(() => repository.registerUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
