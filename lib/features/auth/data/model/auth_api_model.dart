import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_new/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  final String name;
  final String email;
  final String password;
  @JsonKey(name: 'mobile_no')
  final String phone;

  const AuthApiModel({
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  factory AuthApiModel.fromEntity(AuthEntity entity) => AuthApiModel(
        email: entity.email,
        name: entity.name,
        phone: entity.phone,
        password: entity.password,
      );
  AuthEntity toEntity() => AuthEntity(
        email: email,
        name: name,
        phone: phone,
        password: password,
      );

  @override
  List<Object?> get props => [name, password, email, phone];
}
