import 'dart:async';

import 'package:flutter3_app/domain/helpers/domain_errors.dart';

import '../../../domain/usecases/user_authentication.dart';
import 'login_view.dart';

class LoginState {
  bool isLoading = false;
  late String loginAuthError;
}

class StreamLoginPresenter {
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  Stream<String> get loginAuthErrorStream =>
      _controller.stream.map((state) => state.loginAuthError).distinct();

  StreamLoginPresenter({required this.authentication});

  void _update() => _controller.add(_state);

  Future<void>? auth(LoginParams loginParams) async {
    _state.isLoading = true;
    _update();

    try {
      await authentication.auth(loginParams);
    } on DomainError catch (error) {
      _state.loginAuthError = error.description;
    }
    _state.isLoading = false;
    _update();
  }
}
