import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:my_new/features/profile/domain/repositories/profile_repository.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

class UpdateProfilePicture implements UsecaseWithParams<bool, File> {
  final ProfileRepository repository;

  UpdateProfilePicture(this.repository);

  @override
  Future<Either<Failure, bool>> call(File image) async {
    try {
      final res = await repository.updateProfileImage(image);

      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
