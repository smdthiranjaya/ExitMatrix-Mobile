import 'package:bloc/bloc.dart';
import 'package:exitmatrix/services/authenticate.dart';
import 'package:flutter/material.dart';

part 'reset_password_state.dart';

// Cubit class to handle reset password logic
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit()
      : super(ResetPasswordInitial()); // Constructor to initialize the state

  // Function to reset the password using the provided email
  resetPassword(String email) async {
    await FireStoreUtils.resetPassword(
        email); // Call to FireStoreUtils to reset the password
    emit(
        ResetPasswordDone()); // Emit the done state after resetting the password
  }

  // Function to check if the form field is valid
  checkValidField(GlobalKey<FormState> key) {
    if (key.currentState?.validate() ?? false) {
      // Check if the form field is valid
      key.currentState!.save(); // Save the form field state
      emit(ValidResetPasswordField()); // Emit the valid field state
    } else {
      emit(ResetPasswordFailureState(
          errorMessage:
              'Invalid email address.')); // Emit failure state if the email is invalid
    }
  }
}
