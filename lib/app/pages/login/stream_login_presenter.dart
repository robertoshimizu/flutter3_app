import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter3_app/app/pages/pages.dart';
import 'package:flutter3_app/domain/entities/user_account.dart';
import 'package:flutter3_app/domain/helpers/domain_errors.dart';

import '../../../domain/usecases/user_authentication.dart';

class LoginState {
  bool isLoading = false;
  String? loginAuthError;
}

class StreamLoginPresenter implements LoginPresenter {
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<bool> get isLoadingStream {
    return _controller.stream.map((state) => state.isLoading).distinct();
  }

  Stream<String?> get loginAuthErrorStream {
    return _controller.stream.map((state) => state.loginAuthError).distinct();
  }

  StreamLoginPresenter({required this.authentication});

  void _update() => _controller.add(_state);

  @override
  Future<AccountEntity?>? auth(
      AuthenticationParams AuthenticationParams) async {
    _state.loginAuthError = null;
    _state.isLoading = true;
    _update();

    try {
      var response = await authentication.auth(AuthenticationParams);
      // debugPrint('name: ${response!.name}   token: ${response.token} ');
    } on DomainError catch (error) {
      _state.loginAuthError = error.description;
      // debugPrint('Estado: ${_state.loginAuthError}');
    }
    _state.isLoading = false;
    _update();
    return null;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
