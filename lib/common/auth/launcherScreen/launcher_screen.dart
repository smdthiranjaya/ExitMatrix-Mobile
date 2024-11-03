import 'package:exitmatrix/common/auth/authentication_bloc.dart';
import 'package:exitmatrix/common/auth/login/login_screen.dart';
import 'package:exitmatrix/common/auth/onBoarding/data.dart';
import 'package:exitmatrix/common/auth/onBoarding/on_boarding_screen.dart';
import 'package:exitmatrix/common/nav/nav.dart';
import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/services/helper.dart';
import 'package:exitmatrix/views/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LauncherScreen extends StatefulWidget {
  static String routeName = '/launcher_screen';

  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(CheckFirstRunEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(homebg),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.authState) {
            case AuthState.firstRun:
              pushReplacement(
                  context,
                  OnBoardingScreen(
                    images: imageList,
                    titles: titlesList,
                    subtitles: subtitlesList,
                  ));
              break;
            case AuthState.authenticated:
              pushReplacement(context, Nav());
              break;
            case AuthState.unauthenticated:
              pushReplacement(context, const LoginScreen());
              break;
          }
        },
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Color(colorPrimary)),
          ),
        ),
      ),
    );
  }
}
