import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

// Bloc class to handle sign up logic
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    ImagePicker imagePicker = ImagePicker(); // Initialize image picker

    // Event to retrieve lost data (images) when the app is killed or interrupted
    on<RetrieveLostDataEvent>((event, emit) async {
      final LostDataResponse response = await imagePicker.retrieveLostData();
      if (response.file != null) {
        emit(PictureSelectedState(
            imageData: await response.file!.readAsBytes())); // Emit state with selected picture data
      }
    });

    // Event to choose an image from the gallery
    on<ChooseImageFromGalleryEvent>((event, emit) async {
      if (!kIsWeb &&
          (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          emit(PictureSelectedState(
              imageData: await File(result.files.single.path!).readAsBytes())); // Emit state with selected picture data
        }
      } else {
        XFile? xImage =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (xImage != null) {
          emit(PictureSelectedState(imageData: await xImage.readAsBytes())); // Emit state with selected picture data
        }
      }
    });

    // Event to capture an image using the camera
    on<CaptureImageByCameraEvent>((event, emit) async {
      XFile? xImage = await imagePicker.pickImage(source: ImageSource.camera);
      if (xImage != null) {
        emit(PictureSelectedState(imageData: await xImage.readAsBytes())); // Emit state with captured picture data
      }
    });

    // Event to validate form fields and EULA acceptance
    on<ValidateFieldsEvent>((event, emit) async {
      if (event.key.currentState?.validate() ?? false) { // Validate form fields
        if (event.acceptEula) { // Check if EULA is accepted
          event.key.currentState!.save(); // Save form state
          emit(ValidFields()); // Emit valid fields state
        } else {
          emit(SignUpFailureState(
              errorMessage: 'Please accept our terms of use.')); // Emit failure state if EULA is not accepted
        }
      } else {
        emit(SignUpFailureState(errorMessage: 'Please fill required fields.')); // Emit failure state if form fields are invalid
      }
    });

    // Event to toggle EULA checkbox
    on<ToggleEulaCheckboxEvent>(
        (event, emit) => emit(EulaToggleState(event.eulaAccepted))); // Emit state with EULA checkbox toggle status
  }
}
