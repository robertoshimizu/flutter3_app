import 'package:faker/faker.dart';
import 'package:flutter3_app/app/pages/login/login_view.dart';
import 'package:flutter3_app/app/pages/login/stream_login_presenter.dart';
import 'package:flutter3_app/domain/usecases/user_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  late StreamLoginPresenter sut;
  late AuthenticationSpy authentication;
  late String email;
  late String password;
  late LoginParams loginParams;

  setUp(() {
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    loginParams = LoginParams(email, password);

    // PostExpectation mockAutheticationCall() =>
    //     when(authentication.auth(loginParams));
  });

  test('Should call Authentication with correct email and password', () async {
    await sut.auth(loginParams);
    verify(authentication.auth(loginParams)).called(1);
  });

  test('Should emit correct events when Authentication suceeds', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true,false]));
    await sut.auth(loginParams);
  });
}
