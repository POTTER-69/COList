import 'package:colist_proj/routes/router_generation_config.dart';
  import 'package:colist_proj/screens/on_boarding/on_boarding_services/on_boarding_services.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';

  import 'firebase_options.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await OnBoardingServices.initializeSharedPrefrencesStorage();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,);

    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return ScreenUtilInit(
        designSize: const Size(375,812),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'CoList',
            routerConfig: RouterGenerationConfig.goRouter,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(scaffoldBackgroundColor: Color(0xFFFFFFFF)),
          );
        },
      );
    }
  }