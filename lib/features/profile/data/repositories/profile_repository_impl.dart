import 'dart:io';


import 'package:my_new/features/profile/domain/entities/profile.dart';
import 'package:my_new/features/profile/domain/repositories/profile_repository.dart';

import '../datasources/profile_remote_datasource.dart';
import '../models/update_profile_request.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  const ProfileRepositoryImpl(this.profileRemoteDatasource);

  @override
  Future<bool> updateProfileImage(File file) {
    return profileRemoteDatasource.updateProfileImage(file);
  }

  @override
  Future<Profile> getProfile() async {
    final res = await profileRemoteDatasource.getProfile();
    return res.profile;
  }

  @override
  Future<bool> updateProfile(UpdateProfileRequest request) {
    return profileRemoteDatasource.updateProfile(request);
  }
}
