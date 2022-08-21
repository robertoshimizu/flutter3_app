import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter3_app/domain/entities/user_account.dart';
import 'package:flutter3_app/domain/usecases/user_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<void>? auth(LoginParams loginParams) async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void>? request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call Http Client with correct url', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    final email = faker.internet.email();
    final password = faker.internet.password();

    await sut.auth(LoginParams(email, password));

    verify(httpClient.request(url: url));
  });
}
