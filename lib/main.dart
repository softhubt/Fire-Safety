import 'package:firesafety/Constant/color_constant.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Screens/Authentication_Section/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageServices.initializeSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fire Safety",
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: ColorConstant.white),
      home: const SplashScreen(),
    );
  }
}
