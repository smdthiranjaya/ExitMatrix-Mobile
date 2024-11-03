import 'package:exitmatrix/common/auth/authentication_bloc.dart';
import 'package:exitmatrix/common/auth/signUp/sign_up_bloc.dart';
import 'package:exitmatrix/common/auth/splash/splash_screen.dart';
import 'package:exitmatrix/common/loading_cubit.dart';
import 'package:exitmatrix/services/evacuation_background_service.dart';
import 'package:exitmatrix/services/internet_provider.dart';
import 'package:exitmatrix/services/sign_in_provider.dart';
import 'package:exitmatrix/shared/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'views/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureEasyLoading();
  final evacuationService = EvacuationBackgroundService();
  await evacuationService.initialize();

  // Start monitoring when app launches or when evacuation starts
  await evacuationService.startEvacuationMonitoring();
  runApp(MyApp(initialLocale: Locale('en')));
}

void configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0;
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({Key? key, required this.initialLocale}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _error = false;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
          home: Scaffold(
              body: Center(child: Text('Failed to initialise firebase!'))));
    }

    return BlocProvider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignInProvider()),
          ChangeNotifierProvider(create: (_) => InternetProvider()),
          BlocProvider<LoadingCubit>(
            create: (context) => LoadingCubit(),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            initialRoute: SplashScreen.routeName,
            routes: routes,
          ),
        ),
      ),
    );
  }
}
