import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter3_app/data/http/http_error.dart';
import 'package:flutter3_app/data/usecases/usecases.dart';
import 'package:flutter3_app/domain/usecases/usecases.dart';
import 'package:flutter3_app/infra/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './http_adapter_test.mocks.dart' as mocks;

@GenerateMocks([http.Client])
void main() {
  late mocks.MockClient client;
  late HttpAdapter sut;
  late String url;

  late String email;
  late String password;
  late AuthenticationParams authenticationParams;
  late Map body;

  late String accessToken;
  late String name;

  setUp(() {
    client = mocks.MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();

    email = faker.internet.email();
    password = faker.internet.password();
    authenticationParams = AuthenticationParams(email, password);
    body = RemoteAuthenticationParams.fromDomain(authenticationParams).toJson();

    accessToken = faker.guid.guid();
    name = faker.person.name();
  });

  group('post', (() {
    test('Should call post request with correct values', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response(
          '{"accessToken": "$accessToken", "name": "$name"}', 200));

      final response = await sut.request(url: url, method: 'post', body: body);
      expect(response, {"accessToken": "$accessToken", "name": "$name"});
    });
    test('Should return null if post returns 200 with no data', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 200));

      final response = await sut.request(url: url, method: 'post', body: body);
      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 204));

      final response = await sut.request(url: url, method: 'post', body: body);
      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response(
          '{"accessToken": "$accessToken", "name": "$name"}', 204));

      final response = await sut.request(url: url, method: 'post', body: body);
      expect(response, null);
    });

    test('Should return badRequest if post returns 400', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 400));

      // Notice that here we use a future
      final future = sut.request(url: url, method: 'post', body: body);
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return Unauthorized if post returns 401', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 401));

      // Notice that here we use a future
      final future = sut.request(url: url, method: 'post', body: body);
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return invalidData if post returns 403', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 403));

      // Notice that here we use a future
      final future = sut.request(url: url, method: 'post', body: body);
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return Not Found if post returns 404', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 404));

      // Notice that here we use a future
      final future = sut.request(url: url, method: 'post', body: body);
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenAnswer((_) async => http.Response('', 500));

      // Notice that here we use a future
      final future = sut.request(url: url, method: 'post', body: body);
      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(body),
        encoding: null,
      )).thenThrow(Exception('Trash Ttal'));

      // Notice that here we use a future
      final future = sut.request(url: url, method: 'post', body: body);
      expect(future, throwsA(HttpError.serverError));
    });
  }));

  group('get', () {
    test('get request', () async {
      when(client.get(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      })).thenAnswer((_) async =>
          http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      final response = await sut.request(url: url, method: 'get');
      expect(response, {"userId": 1, "id": 2, "title": "mock"});
    });
  });

  test('Should return server error if no hhtp method is especified', () async {
    // Stub
    when(client.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "accept": "application/json"
      },
      body: jsonEncode(body),
      encoding: null,
    )).thenAnswer((_) async => http.Response('', 403));

    // Notice that here we use a future
    final future = sut.request(url: url, method: '', body: body);
    expect(future, throwsA(HttpError.serverError));
  });
}
