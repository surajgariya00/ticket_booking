import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_booking/Model/custom_colors.dart';
import 'package:ticket_booking/View/signIn_page.dart';
import 'package:ticket_booking/View/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCFiv5RyoNV-nBdWUcLILo-gsbsCmZ-AWM',
              appId: '1:757645374852:android:24e592c37ea3fe0d3059d1',
              messagingSenderId: '757645374852',
              projectId: 'ticket-booking-3d4ff'))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: CustomColors.primaryColor,
          onBackground: Colors.white,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: SignInPage(),
    );
  }
}
