import 'package:bloc/bloc.dart';
import 'package:exitmatrix/services/helper.dart';
import 'package:flutter/cupertino.dart';

part 'loading_state.dart';

// Cubit class to handle loading state
class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit()
      : super(LoadingInitial()); // Constructor to initialize the state

  // Function to show loading indicator
  showLoading(BuildContext context, String message, bool isDismissible) async =>
      await showProgress(context, message, isDismissible);

  // Function to hide loading indicator
  hideLoading() async => await hideProgress();
}
