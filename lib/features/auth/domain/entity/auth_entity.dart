import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String email;
  final String name;
  final String password;
  final String phone;

  const AuthEntity({
    this.userId,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
  });

  @override
  List<Object?> get props => [userId, name, password, email, phone];
}
