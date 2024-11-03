part of 'login_bloc.dart';

abstract class LoginEvent {}

// Event to validate login fields
class ValidateLoginFieldsEvent extends LoginEvent {
  GlobalKey<FormState> key;

  ValidateLoginFieldsEvent(this.key);
}
