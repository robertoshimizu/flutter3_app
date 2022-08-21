import 'package:flutter3_app/app/pages/login/login_view.dart';

abstract class Authentication {
  Future<void>? auth(LoginParams loginParams);
}
