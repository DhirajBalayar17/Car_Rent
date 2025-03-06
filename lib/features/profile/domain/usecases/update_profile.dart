import 'package:dartz/dartz.dart';

import 'package:my_new/features/profile/data/models/update_profile_request.dart';
import 'package:my_new/features/profile/domain/repositories/profile_repository.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

class UpdateProfile implements UsecaseWithParams<bool, UpdateProfileRequest> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfileRequest request) async {
    try {
      final res = await repository.updateProfile(request);

      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
