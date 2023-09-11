//add a login protocol to login_api.dart
import 'package:bloc_practice/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  //singleton pattern
  // const LoginApi._sharedInstance(); //private constructor function of the class
  // static const LoginApi _shared = LoginApi._sharedInstance();
  //factory constructor is used when you have to return the existing constructor of the class
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'name@mail.com' && password == 'password',
      ).then((isLoggedIn) => isLoggedIn ? const LoginHandle.pass() : null);
}
