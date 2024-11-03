import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<ValidateLoginFieldsEvent>((event, emit) {
      // Validate the login fields
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        // Emit a state indicating the login fields are valid
        emit(ValidLoginFields());
      } else {
        // Emit a state indicating login failure with an error message
        emit(LoginFailureState(errorMessage: 'Please fill required fields.'));
      }
    });
  }
}
