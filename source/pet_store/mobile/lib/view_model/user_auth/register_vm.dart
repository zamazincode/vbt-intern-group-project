import 'package:flutter/cupertino.dart';

class RegisterViewModel extends ChangeNotifier {
  String _name = '';
  String _surname = '';
  String _userName = '';
  String _email = '';
  String _password = '';

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get surname => _surname;
  set surname(String value) {
    _surname = value;
    notifyListeners();
  }

  String get userName => _userName;
  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "surname": _surname,
      "userName": _userName,
      "email": _email,
      "password": _password,
    };
  }
}