import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter3_app/domain/usecases/user_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void>? auth(LoginParams loginParams) async {

    await httpClient.request(url: url, method: 'post', body: loginParams.toJson());
  }
}

abstract class HttpClient {
  Future<void>? request(
      {required String url, required String method, Map body});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String email;
  late String password;
  late LoginParams loginParams;


  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();
    loginParams = LoginParams(email, password);

    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Should call Http Client with correct url', () async {
    await sut.auth(loginParams);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: loginParams.toJson()
        ));
  });
}
