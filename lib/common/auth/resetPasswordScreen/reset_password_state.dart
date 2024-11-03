part of 'reset_password_cubit.dart';

// Abstract class representing the state of the reset password process
abstract class ResetPasswordState {}

// Initial state of the reset password process
class ResetPasswordInitial extends ResetPasswordState {}

// State representing a valid reset password field
class ValidResetPasswordField extends ResetPasswordState {}

// State representing a failure in the reset password process
class ResetPasswordFailureState extends ResetPasswordState {
  String errorMessage; // Error message describing the failure

  ResetPasswordFailureState({required this.errorMessage}); // Constructor to initialize the error message
}

// State representing the completion of the reset password process
class ResetPasswordDone extends ResetPasswordState {}
