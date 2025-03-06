import 'package:dartz/dartz.dart';

import 'package:my_new/features/profile/domain/entities/profile.dart';
import 'package:my_new/features/profile/domain/repositories/profile_repository.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

class FetchProfile implements UsecaseWithoutParams<Profile> {
  final ProfileRepository repository;

  FetchProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call() async {
    try {
      final res = await repository.getProfile();
      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
