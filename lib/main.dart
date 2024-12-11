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
          textTheme: GoogleFonts.poppinsTextTheme(), // Use Poppins for all text
          useMaterial3: true, // Enable Material 3 UI features
          bottomAppBarTheme:
              const BottomAppBarTheme(color: ColorConstant.primary),
        ),
        home: const SplashScreen());
  }
}

/*

* If not buy
TODO: Offilne > Subcategory Screen > Course List Screen > By tap on course element, show the course detail

User can see the course detail and course list
also show the buy course buttton at bottom in course detail screen
show the lock icon in course list in course detail screen and if user try to access the course then show the error toast to buy the course

* If buy
If user buy course then show something like active in purchased element box at subcategory screen and if user tap on it, navigate him/her to my course screen which is located at bottom navigation bar's second index

 */