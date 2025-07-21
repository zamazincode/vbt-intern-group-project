import 'package:flutter/cupertino.dart';

class LoginViewModel extends ChangeNotifier {
  String _username = '';
  String _password = '';

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get username => _username;

  set username(String value) {
    _username = value;
    notifyListeners();
  }
}