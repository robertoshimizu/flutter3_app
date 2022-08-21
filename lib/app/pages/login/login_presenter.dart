import 'package:flutter/material.dart';
import 'package:flutter3_app/app/pages/login/login_view.dart';

abstract class LoginPresenter {
  Stream<bool>? get isLoadingStream;
  Stream<String?>? get loginAuthStream;

  Future<void>? auth({@required LoginParams loginParams});
  void dispose();
}
