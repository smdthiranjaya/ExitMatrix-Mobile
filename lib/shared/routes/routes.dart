import 'package:exitmatrix/common/auth/launcherScreen/launcher_screen.dart';
import 'package:exitmatrix/common/auth/login/login_screen.dart';
import 'package:exitmatrix/common/auth/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  LauncherScreen.routeName: (context) => LauncherScreen(),
};
