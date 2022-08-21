import 'dart:async';

import 'package:flutter3_app/app/pages/login/login_presenter.dart';

import '../../../domain/usecases/user_authentication.dart';
import 'login_view.dart';

class LoginState {
  bool isLoading = false;
}

class StreamLoginPresenter {
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading);

  StreamLoginPresenter({required this.authentication});

  void _update() => _controller.add(_state);

  Future<void>? auth(LoginParams loginParams) async {
    _state.isLoading = true;
    _update();
    await authentication.auth(loginParams);
    _state.isLoading = false;
    _update();
  }
}
