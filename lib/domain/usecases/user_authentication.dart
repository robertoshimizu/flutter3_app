import 'package:equatable/equatable.dart';
import 'package:flutter3_app/app/pages/login/login_view.dart';
import 'package:flutter3_app/domain/entities/user_account.dart';

abstract class Authentication {
  Future<AccountEntity>? auth(LoginParams loginParams);
}

class LoginParams extends Equatable{
  late String email;
  late String password; 

  LoginParams(this.email, this.password);

  Map toJson() => {
                  'email': email, 
                  'password': password
                  };

  String get mail {
    return email;
  }

  String get secret {
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
