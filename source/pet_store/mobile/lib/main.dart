import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/view/add_pet/add_pet.dart';
import 'package:mobile/view/home/mainPage.dart';
import 'package:mobile/view/profile/profile.dart';
import 'package:mobile/view/update_pet/update_pet.dart';
import 'package:mobile/view/user_auth/login.dart';
import 'package:mobile/view/user_auth/register.dart';
import 'package:mobile/view_model/user_auth/login_vm.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: PetStore(isLoggedIn: isLoggedIn),
    ),
  );
}

class PetStore extends StatelessWidget {
  final bool isLoggedIn;
  const PetStore({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SF PRO'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      home: isLoggedIn ? const MainPage() : const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => Register(),
        '/mainPage': (context) => MainPage(),
        '/addPet': (context) => AddPet(),
        '/profile': (context) => Profile(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}