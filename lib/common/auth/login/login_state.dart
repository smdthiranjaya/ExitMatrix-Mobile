part of 'login_bloc.dart';

abstract class LoginState {}

// Initial state of the login
class LoginInitial extends LoginState {}

// State when login fields are valid
class ValidLoginFields extends LoginState {}

// State when login fails with an error message
class LoginFailureState extends LoginState {
  String errorMessage;

  LoginFailureState({required this.errorMessage});
}
