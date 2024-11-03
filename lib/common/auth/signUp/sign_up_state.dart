part of 'sign_up_bloc.dart';

// Abstract class representing the states in the sign up process
abstract class SignUpState {}

// Initial state of the sign up process
class SignUpInitial extends SignUpState {}

// State representing that a picture has been selected
class PictureSelectedState extends SignUpState {
  Uint8List? imageData; // Selected image data

  PictureSelectedState({required this.imageData}); // Constructor to initialize image data
}

// State representing a failure in the sign up process
class SignUpFailureState extends SignUpState {
  String errorMessage; // Error message describing the failure

  SignUpFailureState({required this.errorMessage}); // Constructor to initialize error message
}

// State representing valid form fields
class ValidFields extends SignUpState {}

// State representing the toggle status of the EULA checkbox
class EulaToggleState extends SignUpState {
  bool eulaAccepted; // EULA checkbox toggle status

  EulaToggleState(this.eulaAccepted); // Constructor to initialize EULA acceptance status
}
