import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter3_app/data/usecases/usecases.dart';
import 'package:flutter3_app/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './http_adapter_test.mocks.dart' as mocks;

class HttpAdapter {
  final http.Client client;

  HttpAdapter(this.client);

  Future<dynamic>? request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json"
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    try {
      if (method == "post") {
        http.Response response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonBody,
          encoding: null,
        );
        // debugPrint(response.body);
        return response.body.isEmpty ? null : jsonDecode(response.body);
      }
      if (method == "get") {
        var response = await client.get(
          Uri.parse(url),
          headers: headers,
        );
        // debugPrint(response.body);
        return jsonDecode(response.body);
      }
      return {"userId": 1, "id": 2, "title": "mock"};
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

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

    test('get request', () async {
      when(client.get(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      })).thenAnswer((_) async =>
          http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      final response = await sut.request(url: url, method: 'get');
      expect(response, {"userId": 1, "id": 2, "title": "mock"});
    });
  }));
}
