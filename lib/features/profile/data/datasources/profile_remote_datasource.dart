import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_new/features/profile/data/models/profile_response.dart';
import 'package:my_new/features/profile/data/models/update_profile_request.dart';

import '../../../../app/constants/api_endpoints.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileResponse> getProfile();
  Future<bool> updateProfile(UpdateProfileRequest request);
  Future<bool> updateProfileImage(File file);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;
  const ProfileRemoteDatasourceImpl(this.dio);

  @override
  Future<ProfileResponse> getProfile() async {
    try {
      final response = await dio.get(ApiEndpoints.profile);
      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(response.data);
      }
      throw Exception('Failed to load profile');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await dio.put(
          '${ApiEndpoints.updateProfile}/${request.userId}',
          data: request.toJson());
      if (response.statusCode == 200) return true;
      throw Exception('Failed to update profile');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> updateProfileImage(File file) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path,
            contentType: DioMediaType.parse('image/jpeg')),
      });
      final response = await dio.put(ApiEndpoints.uploadPP, data: formData);
      if (response.statusCode == 200) return true;
      throw Exception('Failed to update profile image');
    } catch (e) {
      throw Exception(e);
    }
  }
}
