part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignUpLoading extends SignupState {
  const SignUpLoading();
}

class SignUpSuccess extends SignupState {
  @override
  List<Object> get props => [];
}

class SignUpError extends SignupState {
  final String message;

  const SignUpError({required this.message});

  @override
  List<Object> get props => [message];
}
