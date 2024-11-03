part of 'sign_up_bloc.dart';

// Abstract class representing the events in the sign up process
abstract class SignUpEvent {}

// Event to retrieve lost data (images)
class RetrieveLostDataEvent extends SignUpEvent {}

// Event to choose an image from the gallery
class ChooseImageFromGalleryEvent extends SignUpEvent {
  ChooseImageFromGalleryEvent();
}

// Event to capture an image using the camera
class CaptureImageByCameraEvent extends SignUpEvent {
  CaptureImageByCameraEvent();
}

// Event to validate form fields and EULA acceptance
class ValidateFieldsEvent extends SignUpEvent {
  GlobalKey<FormState> key; // Form key for validation
  bool acceptEula; // EULA acceptance status

  ValidateFieldsEvent(this.key, {required this.acceptEula});
}

// Event to toggle EULA checkbox
class ToggleEulaCheckboxEvent extends SignUpEvent {
  bool eulaAccepted; // EULA checkbox toggle status

  ToggleEulaCheckboxEvent({required this.eulaAccepted});
}
