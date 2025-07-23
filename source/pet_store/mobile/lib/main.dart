import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_store/view/home/mainPage.dart';
import 'package:pet_store/view/user_auth/login.dart';
import 'package:pet_store/view/user_auth/register.dart';
import 'package:pet_store/view_model/user_auth/login_vm.dart';
import 'package:provider/provider.dart';


void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => LoginViewModel()),
      ],
      child: PetStore(),
    ),
  );
}

class PetStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF PRO',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/mainPage',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Register(),
        '/mainPage': (context) => const MainPage(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}