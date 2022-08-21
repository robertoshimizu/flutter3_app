import 'package:equatable/equatable.dart';
import 'package:flutter3_app/app/pages/login/login_view.dart';
import 'package:flutter3_app/domain/entities/user_account.dart';

abstract class Authentication {
  Future<AccountEntity>? auth(LoginParams loginParams);
}

class LoginParams extends Equatable{
  late String? _email;
  late String? _password; 

  LoginParams(this._email, this._password);

  String get email {
    return email;
  }

  String get password {
    return password;
  }

  set setEmail(String email) {
    email = email;
  }

  set setPassword(String password) {
    password = password;
  }
  
  @override
  
  List get props => [email,password];
}
