import 'package:flipkart_task/page/auth/login.dart';
import 'package:flipkart_task/utils/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: "flipkart_task",
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(
                iconTheme: const IconThemeData(color: Colors.black),
                foregroundColor: Colors.white,
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
                backgroundColor: Colors.white),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
