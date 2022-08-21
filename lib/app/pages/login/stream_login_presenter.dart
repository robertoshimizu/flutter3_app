import 'dart:async';

import '../../../domain/usecases/user_authentication.dart';
import 'login_view.dart';

class LoginState {}

class StreamLoginPresenter {
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  StreamLoginPresenter({required this.authentication});

  Future<void>? auth(LoginParams loginParams) async {
    await authentication.auth(loginParams);
  }
}
