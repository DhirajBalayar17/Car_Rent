import 'package:dio/dio.dart';
import 'package:my_new/app/constants/api_endpoints.dart';
import 'package:my_new/features/auth/data/data_source/auth_data_source.dart';
import 'package:my_new/features/auth/data/model/auth_api_model.dart';
import 'package:my_new/features/auth/domain/entity/auth_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) return response.data['data']['token'];

      throw Exception(response.data['msg']);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> registerUser(AuthEntity user) async {
    try {
      var userApiModel = AuthApiModel.fromEntity(user);
      var response = await _dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 200) return response.data['msg'];

      throw Exception(response.data['msg']);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
