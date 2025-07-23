import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/view/home/mainPage.dart';
import 'package:mobile/view/user_auth/login.dart';
import 'package:mobile/view/user_auth/register.dart';
import 'package:mobile/view_model/user_auth/login_vm.dart';

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
      initialRoute: '/',
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