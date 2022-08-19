abstract class LoginPresenter {
  Stream<bool>? get isLoadingStream;
  Stream<String?>? get loginAuthStream;

  void auth();
  void dispose();
}
