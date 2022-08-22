import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity>? auth(AuthenticationParams authenticationParams);
}

class AuthenticationParams extends Equatable {
  late String email;
  late String password;

  AuthenticationParams(this.email, this.password);

  Map toJson() => {'email': email, 'password': password};

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
  List get props => [email, password];
}
