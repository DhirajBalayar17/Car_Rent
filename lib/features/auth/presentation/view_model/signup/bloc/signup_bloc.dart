import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_new/features/auth/domain/use_case/signup_use_case.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUseCase _registerUseCase;

  SignupBloc({
    required RegisterUseCase registerUseCase,
  })  : _registerUseCase = registerUseCase,
        super(SignupInitial()) {
    on<NavigateLoginScreenEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (context) => event.destination),
      );
    });
    on<RegisterUser>(_onRegisterEvent);
  }

  void _onRegisterEvent(
    RegisterUser event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignUpLoading());

    final result = await _registerUseCase.call(RegisterUserParams(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone));

    result.fold(
      (l) => emit(SignUpError(message: l.message)),
      (r) => emit(SignUpSuccess()),
    );
  }
}
