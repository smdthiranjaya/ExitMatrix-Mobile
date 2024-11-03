part of 'on_boarding_cubit.dart';

// Abstract class representing the state of the onboarding process
abstract class OnBoardingState {}

// Initial state of the onboarding process with a count of the current page
class OnBoardingInitial extends OnBoardingState {
  int currentPageCount; // Holds the current page count

  OnBoardingInitial(this.currentPageCount); // Constructor to initialize the current page count
}
