import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

abstract class LoginPresenter {
  Stream<bool>? get isLoadingStream;
  Stream<String?>? get loginAuthErrorStream;

  Future<AccountEntity?>? auth(AuthenticationParams authenticationParams);
  void dispose();
}
