import 'package:flutter/material.dart';
import 'package:flutter3_app/app/pages/login/login_view.dart';

import '../../../domain/usecases/user_authentication.dart';

abstract class LoginPresenter {
  Stream<bool>? get isLoadingStream;
  Stream<String?>? get loginAuthErrorStream;

  Future<void>? auth(LoginParams loginParams);
  void dispose();
}
