import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter3_app/app/pages/login/stream_login_presenter.dart';
import 'package:flutter3_app/domain/entities/user_account.dart';
import 'package:flutter3_app/domain/helpers/domain_errors.dart';
import 'package:flutter3_app/domain/usecases/user_authentication.dart';

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  late StreamLoginPresenter sut;
  late AuthenticationSpy authentication;
  late String email;
  late String password;
  late AuthenticationParams authenticationParams;

  PostExpectation mockAutheticationCall() =>
      when(authentication.auth(authenticationParams));

  void mockAuthentication() {
    mockAutheticationCall().thenAnswer((_) => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAutheticationCall().thenThrow(error);
  }

  setUp(() {
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    authenticationParams = AuthenticationParams(email, password);
  });

  test('Should call Authentication with correct email and password', () async {
    await sut.auth(authenticationParams);
    verify(authentication.auth(authenticationParams)).called(1);
  });

  test('Should emit correct events when Authentication suceeds', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ainda falta escutar se realmente o account foi criado
    await sut.auth(authenticationParams);
  });

  test(
      'Should emit correct events when Authentication fails due to Invalid Credentials',
      () async {
    mockAuthenticationError(DomainError.invalidCredentials);

    expectLater(sut.isLoadingStream, emitsInOrder([false]));
    sut.loginAuthErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth(authenticationParams);
  });

  test('Should emit correct events when Authentication fails unexpectedly',
      () async {
    mockAuthenticationError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([false]));
    sut.loginAuthErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth(authenticationParams);
  });
}
