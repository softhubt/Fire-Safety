// ignore_for_file: deprecated_member_use
import 'package:firesafety/Constant/color_constant.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Screens/Authentication_Section/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
            colorScheme: ColorScheme.fromSeed(
                seedColor: ColorConstant.primary,
                background: ColorConstant.white,
                onBackground: ColorConstant.white),
            textTheme:
                GoogleFonts.poppinsTextTheme(), // Use Poppins for all text
            useMaterial3: true, // Enable Material 3 UI features
            bottomAppBarTheme:
                const BottomAppBarTheme(color: ColorConstant.primary)),
        home: const SplashScreen());
  }
}

/*
TODO: Change the design of the drawer screen
TODO: Change the design of bottom navigation bar to floating
TODO: Add the profile section in drawer
TODO: Change to design of the course list screen
TODO: Change the deisng of the course detail screen [Both Overview and Course]
TODO: Solve the late video inilization error in vide tab
TODO: Add the shimmer effects while the video data is empty also channge the design of video tab
TODO: Solve the render flex error in study material
TODO: Change the design of the study material tab
 */