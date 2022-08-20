abstract class LoginPresenter {
  Stream<bool>? get isLoadingStream;
  Stream<String?>? get loginAuthStream;

  Future<void>? auth();
  void dispose();
}
